pragma solidity ^0.5.0;

contract SocialNetwork {
	string public name;
	uint public postCount = 0;
	mapping(uint => Post) public posts;

	struct Post {
		uint id;
		string content;
		uint tipAmount;
		address payable author;
	}

	event PostCreated(
		uint id,
		string content,
		uint tipAmount,
		address payable author
	);

	event PostTipped(
		uint id,
		string content,
		uint tipAmount,
		address payable author
	);


	constructor() public {
		name = "KXNG Enterprise Social Network";
	}

	function createPost(string memory _content) public {
		// Require content in the post
		require(bytes(_content).length > 0);
		// Incrementing the post count 
		postCount ++;
		// Creating the post
		posts[postCount] = Post(postCount, _content, 0, msg.sender);
		// Trigger event
		emit PostCreated(postCount, _content, 0, msg.sender);
	}

	function tipPost(uint _id) public payable {
		// Make sure the id/post exists
		require(_id > 0 && _id <= postCount);

		//Get the post
		Post memory _post = posts[_id];
		
		//Get the author of the post
		address payable _author = _post.author;
		
		//Pay the author by sending them ether
		address(_author).transfer(msg.value);
		
		//Increment tip amount
		_post.tipAmount = _post.tipAmount + msg.value;
		
		//Update the post 
		posts[_id] = _post;
		
		//Trigger an event 
		emit PostTipped(postCount, _post.content, _post.tipAmount, _author);
	}

}