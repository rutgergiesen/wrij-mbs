import { Injectable, TemplateRef } from '@angular/core';

@Injectable(
  { providedIn: 'root' }
)
export class ToastService {
  toasts: any[] = [];

  show(textOrTpl: string | TemplateRef<any>) {
    this.toasts.push({ textOrTpl});
  }

  showError(textOrTpl: string | TemplateRef<any>) {
    this.toasts.push({ textOrTpl,  classname: 'bg-danger text-light', delay: 15000 } );
  }

  remove(toast: any) {
    this.toasts = this.toasts.filter(t => t !== toast);
  }
}
