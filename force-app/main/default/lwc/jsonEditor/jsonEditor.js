import { LightningElement, api } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import JSONEditorZip from '@salesforce/resourceUrl/vanillajsoneditor';

export default class JsonEditor extends LightningElement {
    @api jsonString;
    editor;
    _initialized = false;

    renderedCallback() {
        if (this._initialized) {
            return;
        }
        this._initialized = true;

        Promise.all([
            loadScript(this, JSONEditorZip + '/standalone.js'),
            loadStyle(this, JSONEditorZip + '/vanilla-jsoneditor.css')
        ])
            .then(() => {
                const container = this.template.querySelector('.jsoneditor');
                try {
                    this.editor = new JSONEditor({
                        target: container,
                        props: {
                            content: {
                                json: this.jsonString ? JSON.parse(this.jsonString) : {}
                            },
                            onChange: (updatedContent, previousContent, { contentErrors, patchResult }) => {
                                const newJsonString = JSON.stringify(updatedContent.json, null, 4);
                                if (newJsonString !== this.jsonString) {
                                    this.dispatchEvent(new CustomEvent('change', { detail: newJsonString }));
                                }
                            }
                        }
                    });
                } catch (error) {
                    console.error('Error parsing JSON:', error);
                }
            })
            .catch(error => {
                console.error('Error loading JSONEditor:', error);
            });
    }

    disconnectedCallback() {
        if (this.editor) {
            this.editor.destroy();
        }
    }
}
