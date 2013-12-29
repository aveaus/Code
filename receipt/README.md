Receipt
==========
### Issues with the sales tax
For "1 box of imported chocolates at 11.25", it is an exempt food item (so no sales tax), but it has an import tax of 0.56 (11.25 * 0.05). Base on the logic of rounding up tax to the nearest nickle, it should NOT be rounded. Then the total price of the item should be 11.25+0.56=11.81, which is NOT the same as the input ("1 imported box of chocolates: 11.85").

I believe it should round up the sales tax, but NOT the total price. So 11.81 should be correct.

### Deploy & Tests
`$ bundle install`

`$ rails server`

`http://localhost:3000`

`rake jasmine:ci`

### Other assumptions
* This is a small form that can be inserted into a large dashboard
* User will enter one item at a time
* User will explicitly mark whether the item is exempted and imported
* Once user click on 'Calculate' they can't go back to add more items
* User has to clear the form first, then enter new items
* Sales Tax: from the sameple input, the sales tax needed to be displayed seems to be `sales tax + import tax`


