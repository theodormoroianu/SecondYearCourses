$(document).ready(function () {
    if ($('#page-enrol-index #succesModal').length) {
        setTimeout(function () {
           
            $('#page-enrol-index #succesModal').modal('show');
    }, 600);
    }
    if ($('#page-enrol-index #gdprModal').length) {
        var linkredirect = M.cfg.wwwroot + '/course/index.php?categoryid=174';
        setTimeout(function () {
           
                $('#page-enrol-index #gdprModal').modal('show');
                $('.gdpr-close').click(function(){
                    window.location.href= linkredirect;
                 })
                 $('#page-enrol-index #gdprModal').modal({
                    backdrop:'static',
                    keyboard:false
                 })
        }, 600);
       
    }


});