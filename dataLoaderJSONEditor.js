import { LightningElement, wire, track } from "lwc";
import getStaticResourceContent from "@salesforce/apex/DataLoaderJSONEditor.getStaticResourceContent";
import configUploadFile from "@salesforce/apex/DataLoaderJSONEditor.configUploadFile";
import getAllSObjectNames from "@salesforce/apex/DataLoaderJSONEditor.getAllSObjectNames";
import createDataloaderExternalIdField from "@salesforce/apex/DataLoaderJSONEditor.createDataloaderExternalIdField";
import uploadData from "@salesforce/apex/DataLoaderJSONEditor.uploadData";
import setDataloaderExternalIdFieldBySObjectType from "@salesforce/apex/DataLoaderJSONEditor.setDataloaderExternalIdFieldBySObjectType";
import setPermission from "@salesforce/apex/DataLoaderJSONEditor.setPermission";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const columns = [
  {
    label: "staticResourceName",
    fieldName: "staticResourceName",
    sortable: true
  },
  { label: "sObjectType", fieldName: "sObjectType", sortable: true },
  { label: "group", fieldName: "group", sortable: true },
  { label: "priority", fieldName: "priority", sortable: true },
  { label: "query", fieldName: "query" }
];

export default class DataLoaderJSONEditor extends LightningElement {
  spinner = true;
  configData;
  selectedSobjectType;
  @track sObjectTypes = [];

  //Rows that only has to do with filters
  columns = columns;
  dataTable;
  @track filteredData;
  @track filters = {
    staticResourceName: "",
    sObjectType: "",
    group: "",
    query: ""
  };

  defaultsort = "asc";
  sortDirection = "asc";
  sortedBy;

  radioButtonValue = "staticresource";
  loadingCount = 2;

  handleLoading() {
    this.loadingCount--;
    if (this.loadingCount === 0) {
      this.spinner = false;
    }
  }

  @wire(getAllSObjectNames)
  wiredSObjectTypes({ data, error }) {
    this.handleError(error);
    if (data) {
      this.sObjectTypes = data.map((x) => ({
        label: x,
        value: x
      }));
    }
    this.handleLoading();
  }

  @wire(getStaticResourceContent, { staticResourceName: "DataLoaderConfig" })
  configLoad({ data, error }) {
    this.handleError(error);
    this.dataTable = [];
    this.filteredData = [];

    if (data) {
      try {
        this.configData = data;
        const parsedData = JSON.parse(this.configData);

        if (Array.isArray(parsedData)) {
          this.dataTable = parsedData;
          this.filteredData = [...this.dataTable];
        } else {
          throw new Error("Configuration data is not a valid JSON array.");
        }
      } catch (e) {
        this.handleError(
          new Error(
            `Invalid JSON in DataLoaderConfig static resource. Details: ${e.message}`
          )
        );
      }
    }
    this.handleLoading();
  }

  // Handle radio button change
  loadTypeRadioButtonOnChange(event) {
    this.radioButtonValue = event.detail.value;
  }

  get options() {
    return [
      { label: "Static resource", value: "staticresource" },
      { label: "SObject", value: "sobject" }
    ];
  }

  // Used to sort the 'Age' column
  tableSortBy(field, reverse, primer) {
    const key = primer
      ? function (x) {
          return primer(x[field]);
        }
      : function (x) {
          return x[field];
        };

    return function (a, b) {
      a = key(a);
      b = key(b);
      return reverse * ((a > b) - (b > a));
    };
  }

  // Handle Filter Change
  tableHandleFilterChange(event) {
    const filterType = event.target.dataset.filter;
    const filterValue = event.target.value.toLowerCase();

    this.filters = { ...this.filters, [filterType]: filterValue };
    this.applyFilters();
  }

  applyFilters() {
    this.filteredData = this.dataTable.filter((item) => {
      return (
        (this.filters.staticResourceName
          ? item.staticResourceName
              .toLowerCase()
              .includes(this.filters.staticResourceName)
          : true) &&
        (this.filters.sObjectType
          ? item.sObjectType.toLowerCase().includes(this.filters.sObjectType)
          : true) &&
        (this.filters.group
          ? item.group.toLowerCase().includes(this.filters.group)
          : true) &&
        (this.filters.query
          ? item.query.toLowerCase().includes(this.filters.query)
          : true)
      );
    });
  }

  tableOnHandleSort(event) {
    const { fieldName: sortedBy, sortDirection } = event.detail;
    this.sortDirection = sortDirection;
    this.sortedBy = sortedBy;

    const cloneData = [...this.filteredData];
    cloneData.sort(this.tableSortBy(sortedBy, sortDirection === "asc" ? 1 : -1));

    this.filteredData = cloneData;
  }

  configDataOnChange(event) {
    this.configData = event.detail.value;
  }

  async configSave() {
    await this.withSpinner(async () => {
      await configUploadFile({ fileData: this.configData });
      this.dataTable = JSON.parse(this.configData);
      this.filteredData = [...this.dataTable];
    });
  }

  async configNewEntry() {
    await this.withSpinner(async () => {
      await createDataloaderExternalIdField({
        sObjectType: this.selectedSobjectType
      });
      const newEntry = {
        staticResourceName: `DataLoader${this.selectedSobjectType}`,
        sObjectType: this.selectedSobjectType,
        group: this.selectedSobjectType,
        priority: -1,
        query: `SELECT DataloaderExternalId__c FROM ${this.selectedSobjectType} WHERE DataloaderExternalId__c != NULL Order By DataloaderExternalId__c`
      };
      this.dataTable = [...this.dataTable, newEntry];
      this.filteredData = [...this.dataTable];
      this.configData = JSON.stringify(this.dataTable, null, 2);
    });
  }


  async configSetPermission() {
    this.withSpinner(async () => {
      await setPermission({
        sObjectType: this.selectedSobjectType
      });
    });
  }


  async configSetUUID() {
    this.withSpinner(async () => {
      await setDataloaderExternalIdFieldBySObjectType({
        sObjectType: this.selectedSobjectType
      });
    });
  }

  sObjectSelected(event) {
    this.selectedSobjectType = event.target.value;
  }

  async loadData() {
    await this.withSpinner(async () => {
      await uploadData({
        data: this.template.querySelector("lightning-datatable").getSelectedRows(),
        type: this.radioButtonValue
      });
    });
  }

  async withSpinner(callback) {
    this.spinner = true;
    try {
      await callback();
    } catch (error) {
      this.handleError(error);
    } finally {
      this.spinner = false;
    }
  }

  handleError(error) {
    if (error) {
      const message = error.body ? error.body.message : error.message;
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error",
          message,
          variant: "error"
        })
      );
    }
  }
}