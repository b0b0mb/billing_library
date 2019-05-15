# billing_library

A billing system which handles the sale of a manufacturer's widgets and has the capability of producing sale reports.

# Types of sale
1. Direct sale by manufacturer
  * Sells for $100
2. Affiliate
  * Each affiliate has its own sale price
  * Payback to manufacturer is a 3-tiered pricing scheme based on how many widgets it sells in a month
    1. 0-500 widgets: $60 per widget
    2. 501-1000: $50 per widget
    3. 1001+: $40 per widget
3. Reseller
  * Each reseller has its own sale price
  * Payback to manufacturer is $50 per widget
  
---
# Setup
Inside project directory:
```
bundle install
```
---
# Generating reports from fake orders
From IRB command line:
```
require_relative 'app/lib/fake_order_generator.rb'
require_relative 'app/lib/report_generator.rb'
fg = FakeOrderGenerator.new
rg = ReportGenerator.new(sellers: fg.sellers, direct_sales: fg.direct_sales_count)
rg.billing
rg.seller_profits
rg.company_revenue
```
  
--- 
# Classes

## Affiliate
### Constructor
Initialize with the affiliate's name and widget sale price

    Affiliate.new("affiliate_name", 75.0)
    
### Public Methods
#### order_widgets(quantity)
* Increases the number of widgets sold by quantity
#### profit
* Returns the profit value earned by the seller
#### amount_owed_to_manufacturer
* Returns the amount which seller will be billed by the manufacturer

### Attributes
#### widget_price
* Price which the seller sells each widget for
#### widgets_sold
* Total number of widgets sold by the seller


## Reseller
### Constructor
Initialize with the reseller's name and widget sale price

    Reseller.new("affiliate_name", 75.0)
    
### Public Methods
#### order_widgets(quantity)
* Increases the number of widgets sold by quantity
#### profit
* Returns the profit value earned by the seller
#### amount_owed_to_manufacturer
* Returns the amount which seller will be billed by the manufacturer

### Attributes
#### widget_price
* Price which the seller sells each widget for
#### widgets_sold
* Total number of widgets sold by the seller


## DirectSale

    DirectSale::SALE_PRICE returns the current price manufacturer sells widgets at
    
    
## FakeOrderGenerator
Used to generate fake orders which are randomly created and assigned to 3 affiliates, 2 resellers, and direct sales
### Constructor
Initialize with the number of fake orders you want to generate. *Default value is 100*. Object generates orders upon initialization.

    FakeOrderGenerator.new(100)
    
### Public Methods
#### affiliates
* returns a list of Affiliate objects with random orders
#### resellers
* returns a list of Reseller objects with random orders
#### sellers
* returns a list of Affiliates and Resellers together. This is useful for passing to ReportGenerator

### Attributes
#### direct_sales_count
This attribute has a count of the number of fake orders assigned as direct sales
#### generated_orders
Returns a list of all fake orders
#### order_count
The number of fake orders which were generated



## ReportGenerator
A ReportGenerator object generates 3 different reports based on the 3 types of sale in the billing system.
### Constructor
Initialize with a list of sellers (Affiliate objects and Reseller objects), and direct sales count
```
ReportGenerator.new(sellers: [], direct_sales: 0)
```

### Public Methods
#### billing
Returns a json object containing how much each individual affiliate and reseller owes the manufacturer
#### seller_profits
Returns a json object containing the profit value of each individual affiliate and reseller
#### company_revenue
Returns a json object containing a breakdown of all revenues for the manufacturer.
* Total revenue
* Total revenue from affiliates
* Revenue from each individual affiliate
* Total revenue from resellers
* Revenue from each individual reseller
* Total revenue from direct sales
