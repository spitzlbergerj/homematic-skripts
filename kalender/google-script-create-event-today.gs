function doGet(request) {
  var answer = "sjj.3.2 addtoday";
  answer = createAllDayEventToday(); 
  return ContentService.createTextOutput(answer);
}

function createAllDayEventToday() {
  
  var response = CalendarApp.getDefaultCalendar().createAllDayEvent('raumname', new Date());

  return response;
}

