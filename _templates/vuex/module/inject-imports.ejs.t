---
inject: true
to: src/store/index.example.ts
after: from './typed-vuex';
---

import { <%=name%> } from './<%=name%>/index';
import { <%=Name%>State } from './<%=name%>/state';
import { Mutations as <%=Name%>Mutations } from './<%=name%>/mutations';
import { Actions as <%=Name%>Actions } from './<%=name%>/actions';
import { Getters as <%=Name%>Getters } from './<%=name%>/getters';
