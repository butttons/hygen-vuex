---
to: src/store/<%= name %>/index.ts
---
import { Module } from 'vuex';
import { RootState } from '../index';
import { actions } from './actions';
import { getters } from './getters';
import { mutations } from './mutations';
import { <%=Name%>State, state } from './state';

export const <%=name%>: Module<<%=Name%>State, RootState> = {
    state,
    mutations,
    actions,
    getters,
};
