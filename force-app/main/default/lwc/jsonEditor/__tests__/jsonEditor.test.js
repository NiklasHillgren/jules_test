import { createElement } from '@lwc/engine-dom';
import JsonEditor from 'c/jsonEditor';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';

// Mock the platformResourceLoader
jest.mock(
    'lightning/platformResourceLoader',
    () => {
        return {
            loadScript: jest.fn(),
            loadStyle: jest.fn()
        };
    },
    { virtual: true }
);

// Mock the JSONEditor library
global.JSONEditor = jest.fn(() => {
    return {
        get: jest.fn(() => {
            return { json: { hello: 'world' }, text: undefined };
        }),
        destroy: jest.fn()
    };
});

describe('c-json-editor', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        // Clear all mocks
        jest.clearAllMocks();
    });

    it('loads the vanilla-jsoneditor library and creates the editor', () => {
        // Arrange
        const element = createElement('c-json-editor', {
            is: JsonEditor
        });

        // Act
        document.body.appendChild(element);

        // Assert
        return Promise.resolve().then(() => {
            expect(loadScript).toHaveBeenCalled();
            expect(loadStyle).toHaveBeenCalled();
            expect(JSONEditor).toHaveBeenCalled();
        });
    });

    it('passes the jsonString property to the editor', () => {
        // Arrange
        const element = createElement('c-json-editor', {
            is: JsonEditor
        });
        element.jsonString = '{"hello": "world"}';

        // Act
        document.body.appendChild(element);

        // Assert
        return Promise.resolve().then(() => {
            const editor = element.editor;
            expect(editor.get()).toEqual({ json: { hello: 'world' }, text: undefined });
        });
    });

    it('dispatches a change event when the editor content changes', () => {
        // Arrange
        const element = createElement('c-json-editor', {
            is: JsonEditor
        });
        document.body.appendChild(element);
        const handler = jest.fn();
        element.addEventListener('change', handler);

        // Act
        return Promise.resolve().then(() => {
            const editor = element.editor;
            editor.onChange({ json: { hello: 'updated world' } });
            expect(handler).toHaveBeenCalled();
        });
    });
});
