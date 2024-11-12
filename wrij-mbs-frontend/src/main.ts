/// <reference types="@angular/localize" />

import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { AppModule } from './app/app.module';


platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.error(err));

// platformBrowserDynamic()
//   .bootstrapModule(NgbdToastGlobalModule)
//   .then(ref => {
//     // Ensure Angular destroys itself on hot reloads.
//     if (window['ngRef']) {
//       window['ngRef'].destroy();
//     }
//     window['ngRef'] = ref;

//     // Otherwise, log the boot error
//   })
//   .catch(err => console.error(err));

// platformBrowserDynamic()
//     .bootstrapModule(ToastGlobalComponent)
//     .catch(err => console.error(err));

