pragma solidity >=0.4.25 <0.6.0;

contract BasicProvenance
{

    //Set of States
    enum StateType { Created, InTransit, Completed}
    
    //List of properties
    StateType public  State;
    address public  InitiatingCounterparty;
    address public  Counterparty;
    address public  PreviousCounterparty;
    address public  MedicalPrescriptionOwner;
    address public  MedicalPrescriptionModerator;
    
    constructor(address medicalPrescriptionOwner, address medicalPrescriptionModerator) public
    {
        InitiatingCounterparty = msg.sender;
        Counterparty = InitiatingCounterparty;
        MedicalPrescriptionOwner = medicalPrescriptionOwner;
        MedicalPrescriptionModerator = medicalPrescriptionModerator;
        State = StateType.Created;
    }

    function TransferResponsibility(address newCounterparty) public
    {
        if (Counterparty != msg.sender || State == StateType.Completed)
        {
            revert();
        }

        if (State == StateType.Created)
        {
            State = StateType.InTransit;
        }

        PreviousCounterparty = Counterparty;
        Counterparty = newCounterparty;
    }

    function Complete() public
    {
        if (MedicalPrescriptionModerator != msg.sender || State == StateType.Completed)
        {
            revert();
        }

        State = StateType.Completed;
        PreviousCounterparty = Counterparty;
        Counterparty = 0x0000000000000000000000000000000000000000;
    }
}