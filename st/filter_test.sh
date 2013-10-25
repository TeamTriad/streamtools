clear
echo "tests filter block"
echo "all results in log"
echo "messages with status \"SHOULD PASS\" should be followed by a message."
echo "messages with status \"SHOULD FAIL\" should not followed by a message."
echo ""
echo ""
echo ""

curl "localhost:7070/create?blockType=postto"
curl "localhost:7070/create?blockType=filter"
curl "localhost:7070/create?blockType=tolog"
curl "localhost:7070/create?blockType=postto"

curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test","Comparator":"test","Operator":"eq"}'
curl "localhost:7070/connect?from=1&to=2"
curl "localhost:7070/connect?from=2&to=3"
curl "localhost:7070/connect?from=4&to=3"

echo ""
echo ""
echo "TEST 1: key:value"
echo ""
echo ""
read
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":"test"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":"ok"}'

curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test","Comparator":5,"Operator":"eq"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":5}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":10}'


curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test","Comparator":5,"Operator":"gt"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":10}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":5}'

curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test","Comparator":true,"Operator":"eq"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":true}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":false}'

read
echo ""
echo ""
echo "TEST 2: key:array"
echo ""
echo ""
read
curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[]","Comparator":"one","Operator":"eq"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":["one","two","three"]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":["two","three"]}'

curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[]","Comparator":5,"Operator":"gt"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[5,5,5,5,5,10]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[1,2,3]}'

curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[]","Comparator":true,"Operator":"eq"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[true, false]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[false, false, false]}'


read
echo ""
echo ""
echo "TEST 3: key:value subset"
echo ""
echo ""
read
curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test","Comparator":"world","Operator":"subset"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":"hello world"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":"hello"}'

read
echo ""
echo ""
echo "TEST 4: key:[{key:value}]"
echo ""
echo ""
read
curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[].sub","Comparator":"ok","Operator":"eq"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":"ok"}]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub": 5}]}'

curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[].sub","Comparator":5,"Operator":"eq"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":5}]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":20}]}'

curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[].sub","Comparator":true,"Operator":"eq"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":true}]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":false}]}'

read
echo ""
echo ""
echo "TEST 5: key:[{key:value}] subset"
echo ""
echo ""
read
curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[].sub","Comparator":"yell","Operator":"subset"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":"yellow"}]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":"nope"}]}'

read
echo ""
echo ""
echo "TEST 6: mixed"
echo ""
echo ""
curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[].sub.[]","Comparator":"ok","Operator":"eq"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":["ok","yes","no"]}]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":["no","yes","no"]}]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":null}]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"completely_wrong":null}'

curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[].sub.[]","Comparator":"bees","Operator":"subset"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":["bees are cool","yes","no"]}]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":["no","yes","no"]}]}'

curl "localhost:7070/blocks/2/set_rule" --data '{"Path":"test.[].sub.[].url","Comparator":"fakeurl","Operator":"subset"}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD PASS"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":[{"url":"www.fakeurl.fake/~fake"},{"bad":null}]}]}'
curl "localhost:7070/blocks/4/in" --data '{"STATUS":"SHOULD FAIL"}'
curl "localhost:7070/blocks/1/in" --data '{"test":[{"sub":[null,5,"no"]}]}'

