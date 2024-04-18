contract Topics {
    struct Topic {
        address donator;
        uint256 amount;
        string topic;
    }

    Topic[] public topics; // frontend queries this

    function AddTopic(string memory suggestedTopic) external payable {
        topics.push(
            Topic({
                donator: msg.sender,
                amount: msg.value,
                topic: suggestedTopic
            })
        );
    }

    // more functions for the owner to withdraw
}

contract TopicsEvents {
    event Topic(address indexed donator, uint256 amount, string indexed topic);

    function AddTopic(string memory suggestedTopic) external payable {
        emit Topic(msg.sender, msg.value, suggestedTopic);
    }

    // more functions for the owner to withdraw
}
