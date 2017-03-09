// based on http://stackoverflow.com/questions/14964035/how-to-export-javascript-array-info-to-csv-on-client-side

$(function() {
  
  $('table.table > thead > tr > th:nth-last-child(1)')
    .append('<span class="export-csv" title="Exportă tabela în CSV"></span>');
  $('span.export-csv').on('click', function() {
    var csvFile = '';
    var table = $(this).closest('table');
    table.find('thead > tr > th:not(:last-child)').each(function(idx, th) {
      csvFile += '"' + $(th).text() + '",';
    });
    csvFile += '\n';
    table.find('tbody > tr').each(function(ids, tr) {
      
      $(tr).find('td:not(:last-child)').each(function(idx, td) {
        jtd = $(td)
        if (jtd.find('span.label').length > 0) {
          csvFile += '"';
          var comma = '';
          jtd.find('span.label').each(function(idx, sp) {
            csvFile += comma + $(sp).text().replace(/s+/g, ' ');
            comma = ',';
            });
          csvFile += '",';
        }
        else {
          csvFile += '"' + jtd.text().replace(/[\n\r]/g,'').replace(/\s+/g,' ') + '",';
        }
      });
      csvFile += '\n';
    });
    
    var blob = new Blob([csvFile], { type: 'text/csv;charset=utf-8;' });
    if (navigator.msSaveBlob) { // IE 10+
        navigator.msSaveBlob(blob, filename);
    } else {
        var link = document.createElement("a");
        if (link.download !== undefined) { // feature detection
            // Browsers that support HTML5 download attribute
            var url = URL.createObjectURL(blob);
            link.setAttribute("href", url);
            link.setAttribute("download", 'export.csv');
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }
  });
});
