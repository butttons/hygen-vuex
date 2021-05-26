---
to: src/store/typed-vuex.ts
---
import {
    ActionContext,
    CommitOptions,
    DispatchOptions,
    Store as VuexStore,
} from 'vuex';

type Generic = Record<string, (...args: any[]) => unknown>;

export type TypedActionContext<RS, MS, M extends Generic> = {
    commit<K extends keyof M>(
        key: K,
        payload: Parameters<M[K]>[1],
    ): ReturnType<M[K]>;
} & Omit<ActionContext<MS, RS>, 'commit'>;

export type TypedModule<
    S,
    M extends Generic,
    A extends Generic,
    G extends Generic
> = Omit<VuexStore<S>, 'commit' | 'getters' | 'dispatch'> & {
    commit<K extends keyof M, P extends Parameters<M[K]>[1]>(
        key: K,
        payload: P,
        options?: CommitOptions,
    ): ReturnType<M[K]>;
} & {
    getters: {
        [K in keyof G]: ReturnType<G[K]>;
    };
} & {
    dispatch<K extends keyof A>(
        key: K,
        payload?: Parameters<A[K]>[1],
        options?: DispatchOptions,
    ): ReturnType<A[K]>;
};

export type TypedStore<
    S,
    M extends Generic,
    A extends Generic,
    G extends Generic,
    MT extends Record<string, any>
> = TypedModule<S, M, A, G> & {
    state: S & MT;
};
