$str = "embedd(?:ed|s)?( for)? software";

$str1= "embedded software";
$str1 = "systems  integration";
$str = "system(?:ed|s|)?(?: )?(?:a|all|also|an|and|are|as|at|be|been|before|but|by|can|do|each|etc|for|from|had|has|have|he|his|how|however|i|id|if|in|inc|into|is|it|its|limited|ltd|next|not|now|of|on|or|our|per|pvt|she|than|that|the|their|them|then|there|thereby|these|they|this|those|to|ware|was|we|were|what|when|whenever|where|wherever|which|while|who|will|with|would|you|your)? integration";
if ($str1 =~ /($str)/){print "$1\n";}
1;
