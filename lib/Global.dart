String token = '';
String currentUserUID = '';
var lat;
var long;

//signUp
String signUpOtp = '';
String signUpEmail = '';
String signUpFName = '';
String signUpLName = '';
String signUpGender = '';
String signUpPass = '';
String signUpDob = '';
String signUpCity = '';
List<Map> signUpInterest = [{}];

//reset Password
String resetPasswordOTP = '';
String resetEmail = '';
List referredContacts = [];
List referredAndJoined = [];

String loadMessagesGroupId = '';
String loadMessagesGroupName = '';

//instant match
String instantMatchBody = '';
List instantMatchInterest = [];

String getMemberuid = '';

//groups
String addGroupName = '';
String addGroupDesc = '';
String addGroupType = '1';
List addGroupTags = [];
List addGroupInterest = [];
List addGroupMember = [];
List addGroupMemberEmail = [];

String loadNearby = '';

//events
String addEventName = '';
String addEventDesc = '';
String addEventType = '11';
String addEventStartDate = '';
String addEventStartTime = '';
String addEventEndTime = '';
String addEventLat = '';
String addEventLong = '';
String addEventGoogleId = '';
String addEventGroupMemberId = '';
String addEventGroupId = '';
List addEventTags = [];
String placeName = '';
String placeAddress = '';
Map selectedEvent = {};

//voice call
String agoraToken =
    '0065aec84b1790c4abe8b296ff1294e009dIABLhpk1ws7ANC1e6ddjMpM1D84xrivWpkXdC0ZPdnfOTsJBJDUAAAAAEABFl+dQwaxnYQEAAQC+rGdh';
String agoraAppId = '5aec84b1790c4abe8b296ff1294e009d';
String agoraAppCert = '4e19909f41b64d7b81999ffdafb20f13';
