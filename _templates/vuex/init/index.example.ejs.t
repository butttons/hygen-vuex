---
to: src/store/index.example.ts
---
import { createLogger, createStore } from 'vuex';
import { TypedStore } from './typed-vuex';

export type RootState = {}
export type RootActions = {}
export type RootMutations = {}
export type RootGetters = {}
export interface ModuleTree {

}

export type Store = TypedStore<
    RootState,
    RootMutations,
    RootActions,
    RootGetters,
    ModuleTree
>;

const devPlugins =
    process.env.NODE_ENV === 'production' ? [] : [createLogger()];

export const store = createStore<RootState>({
    modules: {
        
    },
    plugins: [...devPlugins],
});

export const useStore = () => store as Store;
useStore();
