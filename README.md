# Hygen Vuex: Quick scaffolding for vuex 4

### Prerequisites:

-   [hygen](https://github.com/jondot/hygen) - `npm i -g hygen`
-   [hygen-add](https://github.com/jondot/hygen-add) - `npm i -g hygen-add`

### Installation:

-   `hygen-add vuex`

### Usage:

#### Generator:

-   To initialize a new vuex store, use the `init` generator: `hygen vuex init`. This will create 3 files:
    -   `store/index.ts` - Main glue file for all modules and types.
    -   `store/helpers.ts` - Alternatives for the `mapXX` functions from the vuex module, with better type support.
    -   `store/typed-vuex.ts` - Generic types for store and modules.
-   To create a new module, use the `module` generator: `hygen vuex module $NAME`. This will create a folder `store/$NAME` with the following content:
    -   New files: `index.ts`, `state.ts`, `mutations.ts`, `actions.ts`, `getters.ts`
    -   Modifies `store/index.ts` with the imports from the module, injects the module in store instance, and the `ModuleTree` interface.
    -   Only a few manual modifications in `store/index.ts` needed to make it work:
        -   Add the `ModuleMutations` to the `RootMutations` intersection type.
        -   Add the `ModuleActions` to the `RootActions` intersection type.
        -   Add the `ModuleGetters` to the `RootGetters` intersection type.

#### Helpers and `useStore()`:

-   Use the `useStore()` function from the `store/index.ts` file to consume the store.
-   Create helpers using the `useHelpers()` function from `store/helpers.ts` file. `useHelpers` returns these following utilities:
    -   `mapState(module: string, keys: string[])` - Returns a record wrapped in `computed` of the `keys`.
    -   `mapStateStatic(module: string, keys: string[])` - Returns a record with module states' `key` as is.
    -   `mapActions(record: Record<string, keyof RootActions)` - Returns a record with mapped actions.
    -   `mapMutations(record: Record<string, keyof RootMutations>)` - Returns a record with mapped mutations.
    -   `mapGetters(record: Record<string, keyof RootGetters>)` - Returns a record with mapped getters.

##### Example:

`auth/auth.ts`:

```ts
export interface AuthState {
    isAuthenticated: boolean;
    token: string | null;
}
export const state: AuthState = {
    isAuthenticated: false,
    token: null,
};
```

`auth/mutations.ts`:

```ts
import { MutationTree } from 'vuex';
import { AuthState } from './state';

export enum MutationTypes {
    SET_AUTH_STATUS = 'AUTH__SET_AUTH_STATUS',
    SET_TOKEN = 'AUTH__SET_TOKEN',
}
export type Mutations<S = AuthState> = {
    [MutationTypes.SET_AUTH_STATUS]: (state: S, isAuthenticated: boolean) => void;
    [MutationTypes.SET_TOKEN]: (state: S, token: string | null) => void;
};
export const mutations: MutationTree<AuthState> & Mutations = {
    [MutationTypes.SET_AUTH_STATUS]: (state, isAuthenticated) => (state.isAuthenticated = isAuthenticated),
    [MutationTypes.SET_TOKEN]: (state, token) => (state.token = token),
};
```

`auth/actions.ts`:

```ts
import { ActionTree } from 'vuex';
import { RootState } from '../index';
import { TypedActionContext } from '../typed-vuex';
import { Mutations, MutationTypes } from './mutations';
import { AuthState } from './state';

export enum ActionTypes {
    LOGIN = 'AUTH__INIT_LOGIN',
    LOGOUT = 'AUTH__LOGOUT',
}
export type AugmentedActionContext = TypedActionContext<RootState, AuthState, Mutations>;
export type Actions = {
    [ActionTypes.LOGIN]: (context: AugmentedActionContext) => Promise<boolean>;
    [ActionTypes.LOGOUT]: (context: AugmentedActionContext) => Promise<void>;
};
export const actions: ActionTree<AuthState, RootState> & Actions = {
    async [ActionTypes.LOGIN]({ commit }) {
        commit(MutationTypes.SET_AUTH_STATUS, true);
        return true;
    },
    async [ActionTypes.LOGOUT]({ commit }) {
        commit(MutationTypes.SET_AUTH_STATUS, false);
    },
};
```

`src/App.vue`:

```ts
const { mapState, mapActions, mapMutations, mapGetters } = useHelpers();

const { isAuthenticated } = mapState('auth', ['isAuthenticated']);
const { login } = mapActions({ login: ActionTypes.LOGIN });
// ...
await login();
isAuthenticated.value;
```

### Caveats:

1. Helper functions are designed to work with modules only, not the root store.
2. No support for namespaced modules. I recently discovered [template string type improvements](https://devblogs.microsoft.com/typescript/announcing-typescript-4-3-rc/#template-string-type-improvements). Will probably release an updated version with similar function signatures to the official vuex module for the helpers.
