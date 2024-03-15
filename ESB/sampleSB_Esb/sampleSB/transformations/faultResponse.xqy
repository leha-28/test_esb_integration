xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)


declare variable $errorMapXML as element() external;
declare variable $NCxmlErrResp as element() external;
declare variable $faultCode as xs:string external;
declare variable $faultReason as xs:string external;

declare function local:func($errorMapXML as element(), 
                            $NCxmlErrResp as element(), 
                            $faultCode as xs:string, 
                            $faultReason as xs:string) as element(faultResponse) {
    <faultResponse>
    
      <error>
      
        <code>{data($errorMapXML/code)}</code>
      
        <message>{data($errorMapXML/description)}</message>
      
        {
        if(exists($NCxmlErrResp/validationElements)) then
          for $val in $NCxmlErrResp/validationElements/validationElement
            return
              <faultTrace>
              
              
                <faultCode>{data($val/typeOfProblem)}</faultCode>
              
                <faultDescription>{data($val/message)}</faultDescription>
              
              
            
              </faultTrace>
            
      
        else
          <faultTrace>
        
          {
          if(exists($NCxmlErrResp/error/userMessage/businessCode)) then
            <faultCode>{data($NCxmlErrResp/error/userMessage/businessCode)}</faultCode>
          else if(exists($NCxmlErrResp/userMessage/businessCode)) then
            <faultCode>{data($NCxmlErrResp/userMessage/businessCode)}</faultCode>
          else if(exists($NCxmlErrResp/businessCode)) then
            <faultCode>{data($NCxmlErrResp/businessCode)}</faultCode>
          else if(exists($NCxmlErrResp/error/faultTrace/faultCode)) then
            <faultCode>{data($NCxmlErrResp/error/faultTrace/faultCode)}</faultCode>
          else
            <faultCode>{data($faultCode)}</faultCode>
          }
        
          {
          if(exists($NCxmlErrResp/error/userMessage/message)) then
            <faultDescription>{data($NCxmlErrResp/error/userMessage/message)}</faultDescription>
          else if(exists($NCxmlErrResp/userMessage/message)) then
            <faultDescription>{data($NCxmlErrResp/userMessage/message)}</faultDescription>
          else if(exists($NCxmlErrResp/userMessage)) then
            <faultDescription>{data($NCxmlErrResp/userMessage)}</faultDescription>
          else if(exists($NCxmlErrResp/error/faultTrace/faultDescription)) then
            <faultDescription>{data($NCxmlErrResp/error/faultTrace/faultDescription)}</faultDescription>
          else
            <faultDescription>{data($faultReason)}</faultDescription>
          }
      
          </faultTrace>
          }
      
      </error>
      
    </faultResponse>
};

local:func($errorMapXML, $NCxmlErrResp, $faultCode, $faultReason)