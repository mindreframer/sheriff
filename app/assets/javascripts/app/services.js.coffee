# http://docs.angularjs.org/#!angular.service *
angular.module('Alerts', ($resource)->
 $resource('alerts/:alert_id', {},
                  { 'index': { method: 'GET', isArray: true }});
);

angular.module('Deputies', ($resource)->
 $resource('deputies/:deputy_id', {},
                  { 'index': { method: 'GET', isArray: true }});
);

angular.module('Groups', ($resource)->
 $resource('groups/:group_id', {},
                  { 'index': { method: 'GET', isArray: true }});
);

angular.module('SelectedPhotos', ($resource)->
 $resource('selected_photos/:selected_photo_id', {},
                      'create': { method: 'POST' },
                      'index':  { method: 'GET', isArray: true },
                      'update': { method: 'PUT' },
                      'destroy': { method: 'DELETE' });
);
