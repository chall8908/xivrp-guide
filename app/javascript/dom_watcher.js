const callbacks = {
  nodeAdded: [],
  nodeRemoved: []
};

let watcher;

export const registerWatcher = (event, callback) => {
  if(!callbacks[event]) {
    throw `Invalid event type: ${event}`
  }

  callbacks[event].push(callback)
};

export function watch() {
  watcher = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {

      if(mutation.addedNodes.length > 0) {
        callbacks.nodeAdded.forEach((callback) => {
          mutation.addedNodes.forEach(node => callback(node));
        });
      }

      if(mutation.removedNodes.length > 0) {
        callbacks.nodeRemoved.forEach((callback) => {
          mutation.removedNodes.forEach(node => callback(node));
        });
      }
    })
  });

  watcher.observe(document.body, { childList: true, subtree: true });
}

document.addEventListener('DOMContentLoaded', watch)

export default {
  registerWatcher: registerWatcher,
  watch: watch
}
