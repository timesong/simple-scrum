var itemDicts = {}

function loadBoard(docElem) {
  var kanban = docElem.querySelector('.kanban');
  var board = kanban.querySelector('.board');
  var itemContainers = Array.prototype.slice.call(kanban.querySelectorAll('.board-column-content'));
  var columnGrids = [];
  var dragCounter = 0;
  var boardGrid;
  var lastDragItem;

  itemContainers.forEach(function (container) {
    var muuri = new Muuri(container, {
      items: '.board-item',
      layoutDuration: 400,
      layoutEasing: 'ease',
      dragEnabled: true,
      dragSort: function () {
        return columnGrids;
      },
      dragSortInterval: 0,
      dragContainer: document.body,
      dragReleaseDuration: 400,
      dragReleaseEasing: 'ease'
    })
    .on('dragStart', function (item) {
      ++dragCounter;
      docElem.classList.add('dragging');
      item.getElement().style.width =  item.getWidth() + 'px';
      item.getElement().style.height = item.getHeight() + 'px';
    })
    .on('dragEnd', function (item, event) {
      if (--dragCounter < 1 && lastDragItem == item) {
        var allItems = muuri.getItems();
        var ids = []

        for (var i=0; i<allItems.length; ++i) {
          ids.push(allItems[i].getElement().getAttribute("data"));
        }

        var backlog_id = docElem.getAttribute("data")
        $.post('/scrum_update_pbis/'+backlog_id, {
					ids: ids.join(",")
				}, function (data) {
					console.debug(data);
				})

        docElem.classList.remove('dragging');
        lastDragItem = null;
      }
    })
    .on('dragReleaseEnd', function (item) {
      item.getElement().style.width = '';
      item.getElement().style.height = '';

      columnGrids.forEach(function (muuri) {
        muuri.refreshItems();
      });
    })
    .on('layoutStart', function () {
      boardGrid.refreshItems().layout();
    })
    .on('dragMove', function (item, event) {
      lastDragItem = item;
    })
    .on('send', function(data) {
      console.log(data);
    });

    columnGrids.push(muuri);
  });

  var boardGrid = new Muuri(board, {
      layoutDuration: 400,
      layoutEasing: 'ease',
      dragEnabled: true,
      dragSortInterval: 0,
      dragStartPredicate: {
        handle: '.board-column-header'
      },
      dragReleaseDuration: 400,
      dragReleaseEasing: 'ease'
    });
}

function move_to_sprint(issue_id, sprint_id) {
  var docElem = document.querySelector('#backlogs');
  var backlog_id = docElem.getAttribute("data")

  $.post('/scrum-backlog-to-sprint/'+backlog_id, {
    sprint_id: sprint_id,
    issue_id: issue_id
  }, function (data) {
    if (data.ok) {
      location.reload();
    }
  })
}

document.addEventListener('DOMContentLoaded', function () {
  var docElem = document.querySelector('#backlogs');
  loadBoard(docElem);
  docElem = document.querySelector('#sprints');
  loadBoard(docElem);
})

function objectifyForm(formArray) {
  var returnArray = {};

  for (var i = 0; i < formArray.length; i++){
    returnArray[formArray[i]['name']] = formArray[i]['value'];
  }

  return returnArray;
}

$(document).ready(function() {
  var docElem = document.querySelector('#backlogs');
  var backlog_id = docElem.getAttribute("data")

  $("#new-issue-form button.submit").click(function() {
    $.post('/scrum-create-pbi/'+backlog_id, objectifyForm($("#new-issue-form").serializeArray()), function(data) {
      console.debug(data)
    })
  })
})
