---
to: src/store/<%= name %>/getters.ts
---
import { GetterTree } from 'vuex';
import { RootState } from '../index';
import { <%=Name%>State } from './state';

export enum GetterTypes {
    
}
export type Getters = {
    /*
    GETTER_NAME: (state: <%=Name%>State) => unknown;
    */
};
export const getters: GetterTree<<%=Name%>State, RootState> & Getters = {
    
};
