pragma solidity ^0.6.0;

contract Land {
    address contractOwner;

    constructor() public{
        contractOwner = msg.sender;
    }

    struct Landreg {
        uint id;
        uint area;
        string landAddress;
        uint landPrice;
        string allLatitudeLongitude;
        uint propertyPID;
        string physicalSurveyNumber;
        string document;
        bool isforSell;
        address payable ownerAddress;
        bool isLandVerified;
    }

    struct User{
        address id;
        string name;
        uint age;
        string city;
        string aadharNumber;
        string panNumber;
        string document;
        string email;
        bool isUserVerified;
    }

    struct LandInspector {
        uint id;
        address _addr;
        string name;
        uint age;
        string designation;
        string city;
    }

    struct LandRequest{
        uint reqId;
        address payable sellerId;
        address payable buyerId;
        uint landId;
        reqStatus requestStatus;
        bool isPaymentDone;
    }
    enum reqStatus {requested,accepted,rejected,paymentdone,commpleted}


    uint inspectorsCount;
    uint public userCount;
    uint public landsCount;
    uint public documentId;
    uint requestCount;

    
    mapping(address => LandInspector) public InspectorMapping;
    mapping(uint => address[]) allLandInspectorList;
    mapping(address => bool)  RegisteredInspectorMapping;
    mapping(address => User) public UserMapping;
    mapping(uint => address)  AllUsers;
    mapping(uint => address[])  allUsersList;
    mapping(address => bool)  RegisteredUserMapping;
    mapping(address => uint[])  MyLands;
    mapping(uint => Landreg) public lands;
    mapping(uint => LandRequest) public LandRequestMapping;
    mapping(address => uint[])  MyReceivedLandRequest;
    mapping(address => uint[])  MySentLandRequest;
    mapping(uint => uint[])  allLandList;
    mapping(uint => uint[])  paymentDoneList;


    function isContractOwner(address _addr) public view returns(bool){
        if(_addr==contractOwner)
            return true;
        else
            return false;
    }

    function changeContractOwner(address _addr)public {
        require(msg.sender==contractOwner,"you are not contractOwner");

        contractOwner=_addr;
    }

    //-----------------------------------------------LandInspector-----------------------------------------------

    function addLandInspector(address _addr,string memory _name, uint _age, string memory _designation,string memory _city) public returns(bool){
        if(contractOwner!=msg.sender)
            return false;
        require(contractOwner==msg.sender);
        RegisteredInspectorMapping[_addr]=true;
        allLandInspectorList[1].push(_addr);
        InspectorMapping[_addr] = LandInspector(inspectorsCount,_addr,_name, _age, _designation,_city);
        return true;
    }

    function ReturnAllLandIncpectorList() public view returns(address[] memory)
    {
        return allLandInspectorList[1];
    }

    function removeLandInspector(address _addr) public{
        require(msg.sender==contractOwner,"You are not contractOwner");
        require(RegisteredInspectorMapping[_addr],"Land Inspector not found");
        RegisteredInspectorMapping[_addr]=false;


        uint len=allLandInspectorList[1].length;
        for(uint i=0;i<len;i++)
        {
            if(allLandInspectorList[1][i]==_addr)
            {
                allLandInspectorList[1][i]=allLandInspectorList[1][len-1];
                allLandInspectorList[1].pop();
                break;
            }
        }
    }

    function isLandInspector(address _id) public view returns (bool) {
        if(RegisteredInspectorMapping[_id]){
            return true;
        }else{
            return false;
        }
    }
//-----------------------------------------------User-----------------------------------------------

    function isUserRegistered(address _addr) public view returns(bool)
    {
        if(RegisteredUserMapping[_addr]){
            return true;
        }else{
            return false;
        }
    }

    function registerUser(string memory _name, uint _age, string memory _city,string memory _aadharNumber, string memory _panNumber, string memory _document, string memory _email
    ) public {

        require(!RegisteredUserMapping[msg.sender]);

        RegisteredUserMapping[msg.sender] = true;
        userCount++;
        allUsersList[1].push(msg.sender);
        AllUsers[userCount]=msg.sender;
        UserMapping[msg.sender] = User(msg.sender, _name, _age, _city,_aadharNumber,_panNumber, _document,_email,false);
        
    }

    function verifyUser(address _userId) public{
        require(isLandInspector(msg.sender));
        UserMapping[_userId].isUserVerified=true;
    }
