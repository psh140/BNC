function isNotEmpty(obj){
	if(obj.value.length <= 0){
		return false;
	}
	else{
		return true;
	}
}

function isID(obj){
	 var regExp = /^[A-Za-z0-9]+$/;

	if(obj.value.length <= 0){
		alert('아이디를 입력해 주세요.');
		return;
	}
	else{
		if(regExp.test(obj.value)){
			return true;
		}
		else{
			alert('사용 불가능한 아이디 입니다.');
			return false;
		}
	}
}

function isEmail(obj){
	
	var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,4}$/i;

    if(obj.value.length <= 0){
		alert('이메일를 입력해 주세요.');
		return;
	}
	else{
		if(regExp.test(obj.value)){
			return true;
		}
		else{
			alert('정확한 이메일 주소를 입력해 주세요.');
			return false;
		}
	}
}

function isPhoneSelect(obj){
	
	if(obj.value == ""){
		alert('연락처 앞 번호를 선택해 주세요.');
		return;
	}
	else
	{
		return true;
	}
}

function isPhone(obj){
	var regExp = /^\d{7,8}$/;
	
	if(obj.value.length <= 0){
		alert('연락처를 입력해 주세요.');
		return;
	}
	else{
		if(regExp.test(obj.value)){
			return true;
		}
		else{
			alert('정확한 번호를 입력해 주세요.');
			return false;
		}
	}
}

function isPassword(obj){
	var regExp = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
	
	if(obj.value.length <= 0){
		alert('암호를 입력해 주세요.');
		return;
	}
	else if(obj.value.length < 8 || obj.value.length > 20){
		alert('영문자, 숫자, 특수문자를 조합한 8~20자리 이내의 암호를 입력해 주세요.');
		return;
	}
	else{
		if(regExp.test(obj.value)){
			return true;
		}
		else{
			alert('영문자, 숫자, 특수문자를 조합한 8~20자리 이내의 암호를 입력해 주세요.');
			return false;
		}
	}
}
