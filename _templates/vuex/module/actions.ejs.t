---
to: src/store/<%= name %>/actions.ts
---
import { ActionTree } from 'vuex';
import { TypedActionContext } from '../typed-vuex';
import { RootState } from '../index';
import { Mutations, MutationTypes } from './mutations';
import { <%=Name%>State } from './state';

export enum ActionTypes {
    
}
type AugmentedActionContext = TypedActionContext<RootState, <%=Name%>State, Mutations>;
export type Actions = {
    /*
    ACTION_NAME: (context: AugmentedActionContext) => Promise<boolean>;
    */
}
export const actions: ActionTree<<%=Name%>State, RootState> & Actions = {
    
};
