<?php
/* Name: GenerateResponse
 * Variables: NONE
 * Inputs: Status, Message, Data
 * Modification: NONE
 * Outputs: json_encoded Status, Message and Data
 * Description: Generates success and error responses for the client programs
 */

class status
{
	
	/* these are all of the possible
	 * error codes
	 */
	const SUCCESS = 0;
	const UNEXPECTED = 1;
	const INVALID_LOGIN = 2;
	const USERNAME_TAKEN = 3;
	const QUERY_FAILED = 4;
	const USER_PRIVILEGE_ERROR = 5;
	const INVALID_HOST_INFO = 6;
	const MISSING_INFO = 7;
	const INVALID_USER_INFO = 8;
		
	/**
	 * an array of the default messages that this script
	 * pulls from if no custom one is set
	 * @var ArrayObject::String
	 */
	public static $defaultMessages = array(0 => "Call was successful.",
		"Error was something we didn't expect.",
		"The provided username and/or password was invalid.",
		"The provided username has already been taken.",
		"The query to the SQL server failed.",
		"The user did not have appropriate privilege",
		"There was invalid host information",
		"There was missing input information.",
		"There was invalid user information");
}

/**
 * Takes the error code, a custom message,
 * and possibly the data object
 * @param Int $status the error code
 * @param String $message the custom message
 * @param Object $data the data object
 * @return string
 */
function generateResponse($status, $message, $data)
{	
	if (is_null($message))
	{
		$message = status::$defaultMessages[$status];
	}
	
	// having the status object be it's own attribute
	$response = array("Status" => array("Code" => $status, "Message" => $message), "Data" => $data);
	
	$output = json_encode($response);
	return $output;
}

// mysql_close();
?>