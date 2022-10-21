
process hi
    loop
	put "hi"
    end loop
end hi

process ho
    loop
	put "ho"
    end loop
end ho

process he
    loop
	put "he"
    end loop
end he

fork hi
fork ho
fork he

