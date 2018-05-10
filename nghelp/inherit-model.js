-- A model for JS inheritance
(function() {
  'use strict';

  angular.module('fs-ui.modules.components').factory('AdminCtrlService', [
   'AdminUtilitiesService', AdminCtrlService
  ]);

  function AdminCtrlService(AdminUtilitiesService) {
   var core = {
      model: {},
      greet: function(name) { console.log('Hi there '+name); },
      init: function() {
        this.model = angular.copy(AdminUtilitiesService.initializeModel({
          componentId: this.componentId,
          fieldMap: this.fieldMap,
          branch: this.selectedBranch.branchKey
        }));
      },
      save: function() {
        var aPromise = AdminUtilitiesService.buildStagedOverrides(
          this.model, this.fieldMap, this.selectedBranch.branchKey, this.componentId, this.componentName
        );
        aPromise.ctrl = this;
        aPromise.then(function(foo) {
          console.log('Save OK, now re-init', aPromise);
          aPromise.ctrl.init();
        });
      },
      onchange: function(changes) {
        console.log('Superclass onchange');
        this.init();
      },
      updateModel: AdminUtilitiesService.updateModel,
      attach: function(func, funcName) {
        if (angular.isFunction(func)) {
          if (angular.isString(funcName) && funcName.trim() !== '') {
            this[funcName] = func;
          } else {
            this[func.name] = func;
          }
        }
      }
   };

   var confer = function(source, fieldmap, compId, compName) {
      source['fieldMap'] = fieldmap;
      source['componentId'] = compId;
      source['componentName'] = compName;
      source.resetComponents = [{id: compId, name: compName}];

      angular.forEach(core, function(value, key) {
      // console.log('parent key', key, value, source.hasOwnProperty(key));
        if (!source.hasOwnProperty(key)) {
          source[key] = value;
        }
      });
      source['$onChanges'] = source.onchange;
      return source;
    };

   return {
      'confer': confer
   };
  }
})();

// usage
(function() {
  'use strict';

  angular.module('mymodule')
    .directive(‘superAdminComponent', [superAdminComponent]);

  function SuperAdminCtrl(AdminUtilitiesService, AdminCtrlService,SuperFieldMap) {
    var ctrl = AdminCtrlService.confer(this,
                                SuperFieldMap,
                                'component_super_duper',
                                'Super Duper title');
    // ctrl.attach(AdminUtilitiesService.updateModel);

    ctrl.$onInit = function() {
      console.log('Begin $onInit');
      ctrl.init();
    };
  }

  function superAdminComponent() {
    return {
      restrict: 'E',
      scope: {},
      bindToController: {
        selectedBranch: '<'
      },
      controller: [
        'AdminUtilitiesService', 'AdminCtrlService', ‘SuperFieldMap', SuperAdminCtrl
      ],
      controllerAs: 'ctrl',
      templateUrl: 'superAdminComponent.tpl.html'
    };
  }
})();
