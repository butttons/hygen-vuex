---
to: src/store/helpers.ts
---
import { computed, ComputedRef } from 'vue';
import {
    ModuleName,
    RootActions,
    RootGetters,
    RootMutations,
    Store,
    useStore,
} from './index';

export const createHelpers = <S extends Store>(store: Store) => {
    const storeModuleKeys = (module: ModuleName) =>
        Object.keys(store.state[module]);

    const mapState = <M extends ModuleName, K extends keyof S['state'][M]>(
        module: M,
        keys: K[],
    ) => {
        type MappedState = {
            [P in K]: ComputedRef<S['state'][M][P]>;
        };
        return keys.reduce((acc, key) => {
            if (!storeModuleKeys(module).includes(key as string)) return acc;
            acc[key] = computed(() => store.state[module][key]);
            return acc;
        }, {} as MappedState);
    };

    const mapStateStatic = <
        M extends ModuleName,
        K extends keyof S['state'][M]
    >(
        module: M,
        keys: K[],
    ) => {
        type MappedState = {
            [P in K]: S['state'][M][P];
        };
        return keys.reduce((acc, key) => {
            if (!storeModuleKeys(module).includes(key as string)) return acc;
            acc[key] = store.state[module][key];
            return acc;
        }, {} as MappedState);
    };
    const mapGetters = <T extends Record<string, keyof RootGetters>>(
        record: T,
    ) => {
        type MappedGetters = {
            [P in keyof T]: ComputedRef<ReturnType<RootGetters[T[P]]>>;
        };
        return Object.entries(record).reduce((acc, [key, value]) => {
            if (!Object.keys(store.getters).includes(value as string))
                return acc;
            acc[key as keyof T] = computed(
                () => store.getters[value],
            ) as ComputedRef<ReturnType<RootGetters[T[typeof key]]>>;
            return acc;
        }, {} as MappedGetters);
    };

    const mapActions = <T extends Record<string, keyof RootActions>>(
        record: T,
    ) => {
        type MappedActions = {
            [P in keyof T]: (
                args?: Parameters<RootActions[T[P]]>[1],
            ) => ReturnType<RootActions[T[P]]>;
        };
        return Object.entries(record).reduce((acc, [key, value]) => {
            acc[key as keyof T] = (
                args?: Parameters<RootActions[T[typeof key]]>[1],
            ) =>
                store.dispatch(value as keyof RootActions, args) as ReturnType<
                    RootActions[T[typeof key]]
                >;
            return acc;
        }, {} as MappedActions);
    };
    const mapMutations = <T extends Record<string, keyof RootMutations>>(
        record: T,
    ) => {
        type MappedMutations = {
            [P in keyof T]: (
                args?: Parameters<RootMutations[T[P]]>[1],
            ) => ReturnType<RootMutations[T[P]]>;
        };
        return Object.entries(record).reduce((acc, [key, value]) => {
            acc[key as keyof T] = (
                args?: Parameters<RootMutations[T[typeof key]]>[1],
            ) =>
                store.commit(value as keyof RootMutations, args) as ReturnType<
                    RootMutations[T[typeof key]]
                >;
            return acc;
        }, {} as MappedMutations);
    };

    return {
        mapState,
        mapStateStatic,
        mapGetters,
        mapActions,
        mapMutations,
    };
};

export const useHelpers = () => createHelpers<Store>(useStore());
