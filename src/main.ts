import App from "./App.svelte";
import "./services/db";

const app = new App({
  target: document.body,
  props: {},
});

export default app;
