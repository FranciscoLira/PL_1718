BEGIN				{RS="\n";FS=" "}
/[0-9]{2}:[0-9]{2}/	{print}
/[A-Za-z]+/			{print}
END					{}