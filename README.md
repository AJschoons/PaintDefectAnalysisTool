# Paint Defect Analysis Tool

Prototype paint defect analysis tracking iPad app for Chrysler paint factories.

This prototype was created by Adam Schoonmaker as a term project for CSE 435 at Michigan State University. The purpose of the app is to help analysts in Chrysler paint factories record paint defects on cars as the cars travel down the line. This data is persisted in CoreData, and then uploaded to a dummy server. The idea of this is then the managers would be able to analylize their data over time and see patterns.

Tour of the app is below:

<img width="688" alt="starting screen" src="https://cloud.githubusercontent.com/assets/7013639/12734731/505dd5b6-c910-11e5-8c29-2ab6938a5efb.png">

The starting screen is where an analyst starts a new Analysis for a shift at a specific checkpoint and factory. Once that has been entered, they press "Start," and it will take them to the screen below.

<img width="688" alt="analysis screen" src="https://cloud.githubusercontent.com/assets/7013639/12734843/116820cc-c911-11e5-8214-40858368a2c2.png">

This is the Analysis Samples screen. The data for each car is considered a sample, and those samples are listed here. Samples that have been completed show in black, while unfinished samples appear in red. To add a new sample, the "+" button can be pressed. Previously created samples can be edited by selecting them in the table. Once the analyst has completed the report, they can press the "Finish" button to generate a report.

<img width="688" alt="car sample data collection screen" src="https://cloud.githubusercontent.com/assets/7013639/12734846/16ba64ae-c911-11e5-82be-ed3fd508761d.png">
<img width="688" alt="generated report screen" src="https://cloud.githubusercontent.com/assets/7013639/12734848/1864553a-c911-11e5-86e3-7d15fc7a232e.png">
