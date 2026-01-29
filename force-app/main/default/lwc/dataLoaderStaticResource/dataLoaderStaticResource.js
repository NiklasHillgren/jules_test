import { LightningElement, wire } from "lwc";
import getDataLoaders from "@salesforce/apex/DataLoaderStaticResourceController.getDataLoaders";
import uploadFileForDataLoader from "@salesforce/apex/DataLoaderStaticResourceController.uploadFileForDataLoader";
import { EnclosingTabId, getTabInfo, setTabLabel, setTabIcon } from "lightning/platformWorkspaceApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const COLS = [
	{ label: "SObject", fieldName: "SObjectType__c", type: "text" },
	{ label: "File", fieldName: "StaticResourceName__c", type: "text" },
	{ label: "Order", fieldName: "Order__c", type: "text" },
	{ label: "Progress", fieldName: "Progress", type: "text" }
];

const TAB_LABEL = "File upsert";

export default class DataLoaderStaticResource extends LightningElement {
	columns = COLS;
	dataLoaders = [];
	selectedIds = [];
	isLoading = true;

    _enclosingTabId;

	@wire(EnclosingTabId)
    wiredEnclosingTabId({ data }) {
        if (data) {
            this._enclosingTabId = data;
            this.setTabInfo();
        }
    }

	async setTabInfo() {
        try {
            const tabInfo = await getTabInfo(this._enclosingTabId);
            await Promise.all([
                setTabLabel(tabInfo.tabId, TAB_LABEL),
                setTabIcon(tabInfo.tabId, "utility:file")
            ]);
        } catch (error) {
            console.error("Error setting tab info:", error);
        }
	}

	async handleClick(event) {
		const actionName = event.target.name;
		await this.withSpinner(async () => {
			const loaders = JSON.parse(JSON.stringify(this.dataLoaders));
			for (const loader of loaders) {
				if (actionName === "upsertSelected" && !this.selectedIds.includes(loader.Id)) {
					continue;
				}

				loader.Progress = "In progress";
				this.dataLoaders = [...loaders];

                try {
                    await uploadFileForDataLoader({ loader });
                    loader.Progress = "Upserted";
                } catch (error) {
                    loader.Progress = "Error";
                    throw error;
                }
				this.dataLoaders = [...loaders];
			}
		});
	}

	onSelectedRow(event) {
		this.selectedIds = event.detail.selectedRows.map(row => row.Id);
	}

	@wire(getDataLoaders)
	wireDataLoaders({ data, error }) {
		if (data) {
			this.dataLoaders = data.map(item => ({
                ...item,
                Progress: "Waiting..."
            }));
            this.isLoading = false;
		} else if (error) {
			this.handleError(error);
            this.isLoading = false;
		}
	}

	async withSpinner(callback) {
		this.isLoading = true;
		try {
			await callback();
		} catch (error) {
			this.handleError(error);
		} finally {
			this.isLoading = false;
		}
	}

	handleError(error) {
		if (error) {
			const message = error.body ? error.body.message : error.message;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: message,
                    variant: 'error'
                })
            );
			console.error('Error details:', JSON.stringify(error));
		}
	}
}
