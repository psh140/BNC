	function historyBack(){
		history.back();
	}

	function textTrim(e)
	{
		var a = $(e).val().replace(/ /gi, '');
		$(e).val(a);
	}
	
	function onlyLowerAlphabetNumberText(text)
	{
		var regexp = /^[a-z0-9_-]{3, 15}$/;    
		//var regexp = /[^[a-z0-9]$/g;
		if(regexp.test(text)){
			return false;
		}
		else
		{
			return true;
		}
	}
	
	function onlyLowerAlphabetNumber(e)
	{
		var regexp = /[^[a-z0-9]$/g;
		if(regexp.test($(e).val())){
			alert('영어소문자+숫자만 입력 가능합니다.');
		  	$(e).val($(e).val().replace(regexp,""));
			$(e).focus();
			return false;
		}
	}
	
	function onlyUpperAlphabetNumber(e)
	{
		var regexp = /[^[A-Z0-9]$/g;
		if(regexp.test($(e).val())){
			alert('영어대문자+숫자만 입력 가능합니다.');
		  	$(e).val($(e).val().replace(regexp,""));
			$(e).focus();
			return false;
		}
	}
	
	function onlyNumber(e)
	{
		var regexp = /[^[0-9]$/g;
		if(regexp.test($(e).val())){
			alert('숫자만 입력 가능합니다.');
		  	$(e).val($(e).val().replace(regexp,""));
			$(e).focus();
			return false;
		}
	}
    
	function numberRemoveCommas(x) {
		return parseInt(x.replace(/,/g,""));
	}

	function numberAddCommas(x) {
		
		if(x == 0)
		{
			return 0;
		}
		else{
    		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
	}
	
    function fileBtnClick(e){

    	var btnObj = $(e).parent().find("input");
    	
    	btnObj.click();
           
    	var ext = btnObj.val().split(".").pop().toLowerCase();
    	if(ext.length > 0){
    		if($.inArray(ext, ["gif","png","jpg","jpeg"]) == -1) { 
    			alert("gif,png,jpg 파일만 업로드 할수 있습니다.");
    			return false;  
    		}                  
    	}

    	btnObj.change(function () {
       		readURL(this);
        });
   	}
   	
	function readURL(input) {
		if (input.files && input.files[0]) {
			var reader = new FileReader();
            reader.onload = function(e){
            	$(input).parent().find("img").attr('src', e.target.result)
            }
            reader.readAsDataURL(input.files[0]);
		}
	}