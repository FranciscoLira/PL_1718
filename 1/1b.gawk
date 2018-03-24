BEGIN				{RS="\n";FS=" "}
/[A-Za-z]+/			{print; print"|"}
END					{}