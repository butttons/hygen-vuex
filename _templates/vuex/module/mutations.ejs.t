---
to: src/store/<%= name %>/mutations.ts
---
import { MutationTree } from 'vuex';
import { <%=Name%>State } from './state';

export enum MutationTypes {

}

export type Mutations<S = <%=Name%>State> = {
    /*
    MUTATION_NAME: (
        state: S,
        payload: unknown,
    ) => void;
    */
};

export const mutations: MutationTree<<%=Name%>State> & Mutations = {
    
};
