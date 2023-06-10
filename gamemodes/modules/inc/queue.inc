#include a_samp

#define MAX_QUEUE       5
#define MAX_QUEUE_ITEMS 30

new queue_maxid = 0; // amount of queues created

enum e_queue
{
	q_string_1[110],
	q_string_2[MAX_PLAYER_NAME],
	q_string_3[MAX_PLAYER_NAME],
	q_string_4[24],
	q_int_1,
	q_int_2,
	
	// Be careful when adding more variables: reset them in queue_init and queue_remove
};
new QUEUE[MAX_QUEUE][MAX_QUEUE_ITEMS][e_queue];

enum e_queue_global
{
	q_max_items,
	q_ids[MAX_QUEUE_ITEMS * 4], // *4 because of "123|" format
}
new QUEUE_GLOBAL[MAX_QUEUE][e_queue_global];
//new QUEUE_IDs[MAX_QUEUE][MAX_QUEUE_ITEMS * 4]; // *4 because of "123|" format

stock queue_init(max_items = MAX_QUEUE_ITEMS)
{
	if (max_items < 1 || max_items > MAX_QUEUE_ITEMS) 
	{
		printf("ERROR: Invalid \"max_items\" value for the queue %d in the function queue_init()", queue_maxid);
		
		max_items = MAX_QUEUE_ITEMS;
	}
	
	new queue_id = queue_maxid++;
	QUEUE_GLOBAL[queue_id][q_ids]  	    = EOS;
	QUEUE_GLOBAL[queue_id][q_max_items] = max_items;
	
	
	for__loop (new i = 0; i < max_items; i++)
	{
		queue_reset(queue_id, i);
	}
	
	return queue_id;
}

stock queue_add(queue_id, item_id)
{
	if (queue_id < 0 || queue_id > MAX_QUEUE-1) 
		return printf("ERROR: Invalid queue ID (%d) specified in the function queue_add()", queue_id);
	
	new
		str[6]
	;
	
	if (isnull(QUEUE_GLOBAL[queue_id][q_ids])) // Empty queue, add a leading vertical bar
		format(str, sizeof(str), "|%d|", item_id);
	else
		format(str, sizeof(str), "%d|", item_id);
		
    strins(QUEUE_GLOBAL[queue_id][q_ids], str, strlen(QUEUE_GLOBAL[queue_id][q_ids]));
	
	printf("ids: %s", QUEUE_GLOBAL[queue_id][q_ids]);

	return 1;
}

stock queue_remove(queue_id, item_id)
{
	new
		str[5],
		position
	;
	format(str, sizeof(str), "|%d|", item_id);
	
	printf("ids: %s, str: %s", QUEUE_GLOBAL[queue_id][q_ids], str);
	
	position = strfind(QUEUE_GLOBAL[queue_id][q_ids], str, true);
	if (position != -1) // Found
	{
		strdel(QUEUE_GLOBAL[queue_id][q_ids], position, position + strlen(str) - 1); // -1 in order to leave 1 out of 2 vertical bars
		
		if (!strcmp(QUEUE_GLOBAL[queue_id][q_ids], "|")) // The deleted item was the only in the queue, empty the string to remove the left vertical bar
			QUEUE_GLOBAL[queue_id][q_ids] = EOS;
	}
	else
		printf("ERROR: Unable to remove the item %d from the queue %d", item_id, queue_id);

	return 1;
}

stock queue_count(queue_id)
{
	if (queue_id < 0 || queue_id > MAX_QUEUE-1) 
	{
		printf("ERROR: Invalid queue ID (%d) specified in the function queue_count()", queue_id);
		
		return -1;
	}
	
	new count = 0;
	for__loop (new i = 0, index, len = strlen(QUEUE_GLOBAL[queue_id][q_ids]); i < len; i++)
	{
		index = _:q_ids + i;
	 	if (QUEUE_GLOBAL[queue_id][e_queue_global:index] == '|') count++;
	}

	return count - 1; // -1 because of the leading vertical bar
}

stock queue_first_item(queue_id)
{
	if (queue_id < 0 || queue_id > MAX_QUEUE-1) 
	{
		printf("ERROR: Invalid queue ID (%d) specified in the function queue_first_item()", queue_id);
		
		return -1;
	}
		
	if (isnull(QUEUE_GLOBAL[queue_id][q_ids])) // Queue is empty
		return -1;
	
	new item_id = -1;
	if (sscanf(QUEUE_GLOBAL[queue_id][q_ids], "p<|>ii", item_id, item_id)) // The reason behind this doubling of item_id scan is that, if the string is "|1|", it will detect 0 first, and then 1
	{
		printf("WARNING: Unable to get the first item of the queue %d (queue is empty)", queue_id);
		
		return -1;
	}
	
	return item_id;
}

stock queue_get_item(queue_id, item_position)
{
	if (queue_id < 0 || queue_id > MAX_QUEUE-1)
	{
		printf("ERROR: Invalid queue ID (%d) specified in the function queue_get_item()", queue_id);
		
		return -1;
	}
		
	if (item_position < 1 || item_position >= QUEUE_GLOBAL[queue_id][q_max_items])
	{
		printf("ERROR: Invalid item position (%d) specified for the queue %d in the function queue_get_item()", item_position, queue_id);
	
		return -1;
	}
	
	if (isnull(QUEUE_GLOBAL[queue_id][q_ids])) // Queue is empty
		return -1;
		
	
	new 
		item_id = -1,
		temp[MAX_QUEUE_ITEMS * 4],
		total_items = 0
	;
	
	strmid(temp, QUEUE_GLOBAL[queue_id][q_ids], 1, strlen(QUEUE_GLOBAL[queue_id][q_ids]), sizeof(temp)); // Starting from 1 to remove the leading vertical bar
	for__loop (new i = 0, len = strlen(temp), x = 0; i < len; i++)
	{
		// x variable is here to prevent calling the if() block multiple times.
		// when you have one-digit number, the if() block will be called 2 times instead of 1, and if you have two-digit number, it'll be called 3 times.
		// the x variable prevents this
	
		if (temp[i] == '|')
			total_items++, x++;
			
		if (total_items > item_position)
		{
			printf("WARNING: Requested item on a non-existing position of the queue %d (position: %d)", queue_id, item_position);
			item_id = -1;
			
			break;
		}
			
		if (total_items == (item_position-1) && x != 0)
		{
			strdel(temp, 0, i); // Deletes everything from the beginning to the current point
			x = 0;
			i = 0; // Since we've deleted a big part of the string, we need to reset the counter, since the length is much smaller now
		}
		
			
		if (total_items == item_position)
		{
			strdel(temp, 0, 1); // Deletes the leading vertical bar, leaving something like this: 5|6|7|8| (suppose that the requested item position is 5)
			strdel(temp, i-1, strlen(temp)); // Deletes everything after the first vertical bar, leaving 5 only ( -1 is here because we've already deleted 1 character before (the leading vertical bar)
			item_id = strval(temp);
			
			break;
		}
	}

	// Returns item id or -1 if there's no item on the given position
	return item_id;
}

stock queue_check_item(queue_id, item_id)
{
	if (queue_id < 0 || queue_id > MAX_QUEUE-1) 
	{
		printf("ERROR: Invalid queue ID (%d) specified in the function queue_check_item()", queue_id);
		
		return 0;
	}
	
	if (item_id < 0 || item_id >= QUEUE_GLOBAL[queue_id][q_max_items]) 
	{
		printf("ERROR: Invalid item ID (%d) for the queue %d in the function queue_check_item()", item_id, queue_id);
		
		return 0;
	}
	
	new 
		str[6],
		position
	;
	format(str, sizeof(str), "|%d|", item_id);
	
	position = strfind(QUEUE_GLOBAL[queue_id][q_ids], str);
	if (position != -1)
		return 1;
	return 0;
	
	// Explanation:
	// First check (strfind) checks for something like "|11|"
	// If it's found, the func returns 1 and that's the end
	// If it is not, it checks if there's "11|" at the very beginning (sscanf, and no leading vertical bar)
	// If it's found, the func returns 1, and if it is not, returns 0 -> the end
	
	// The reason behind this double-check is that if we check for "1|" (no leading vert bar), it will also match "11|"
	// So, to avoid it, we first check with a leading vertical bar. However, a vertical bar 
}

stock queue_reset(queue_id, item_id)
{
	if (queue_id < 0 || queue_id > MAX_QUEUE-1) 
	{
		printf("ERROR: Invalid queue ID (%d) specified in the function queue_reset()", queue_id);
		
		return 0;
	}
	
	if (item_id < 0 || item_id >= QUEUE_GLOBAL[queue_id][q_max_items]) 
	{
		printf("ERROR: Invalid item ID (%d) for the queue %d in the function queue_reset()", item_id, queue_id);
		
		return 0;
	}
	
	QUEUE[queue_id][item_id][q_int_1]    = -1;
	QUEUE[queue_id][item_id][q_int_2]    = -1;
	QUEUE[queue_id][item_id][q_string_1] = EOS;
	QUEUE[queue_id][item_id][q_string_2] = EOS;
	QUEUE[queue_id][item_id][q_string_3] = EOS;
	QUEUE[queue_id][item_id][q_string_4] = EOS;
	
	return 1;
}

stock queue_is_empty(queue_id)
{
	if (queue_id < 0 || queue_id > MAX_QUEUE-1) 
	{
		printf("ERROR: Invalid queue ID (%d) specified in the function queue_is_empty()", queue_id);
		
		return 0;
	}
	
	return isnull(QUEUE_GLOBAL[queue_id][q_ids]);
}