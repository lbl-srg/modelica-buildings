within Buildings.Templates.Components.Validation;
model BoilerHotWaterRecord
  "Test model for parameter propagation with the hot water boiler record"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0500 per;

  parameter Buildings.Templates.Components.Data.BoilerHotWater datBoiTab(
    final typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Table,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    per=per,
    mHeaWat_flow_nominal=datBoiTab.cap_nominal/15/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    cap_nominal=1000E3,
    dpHeaWat_nominal(displayUnit="Pa") = 5000,
    THeaWatSup_nominal=333.15)
    "Design and operating parameters for the boiler model using a lookup table"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  parameter Buildings.Templates.Components.Data.BoilerHotWater datBoiTabRed(
    final typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Table,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    redeclare Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0500 per,
    mHeaWat_flow_nominal=datBoiTab.cap_nominal/15/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    cap_nominal=1000E3,
    dpHeaWat_nominal(displayUnit="Pa") = 5000,
    THeaWatSup_nominal=333.15)
    "Design and operating parameters for the boiler model using a lookup table with redeclaration"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  parameter Buildings.Templates.Components.Data.BoilerHotWater datBoiTabLoc(
    final typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Table,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    per(effCur=per.effCur),
    mHeaWat_flow_nominal=datBoiTab.cap_nominal/15/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    cap_nominal=1000E3,
    dpHeaWat_nominal(displayUnit="Pa") = 5000,
    THeaWatSup_nominal=333.15)
    "Design and operating parameters for the boiler model using a local assignment of the efficiency curve "
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  annotation (
  experiment(
    StopTime=1,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/BoilerHotWaterRecord.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the parameter propagation within the record class
<a href=\"modelica://Buildings.Templates.Components.Data.BoilerHotWater\">
Buildings.Templates.Components.Data.BoilerHotWater</a>.
It illustrates
</p>
<ul>
<li>
how to assign a value to the efficiency curve either manually 
(<code>datBoiTabLoc.per.effCur</code>) or by the means of a record redeclaration 
(<code>datBoiTabRed.per.effCur</code>) or record binding (<code>datBoiTab.per.effCur</code>),
</li>
<li>
how the original bindings for other design parameters such as the 
HW flow rate and capacity persist when redeclaring the performance record
<code>datBoiTabRed.per</code>,
</li>
<li>
how to completely overwrite the original bindings to the design conditions
when assigning an instance of a compatible record to <code>datBoiTab.per</code>.
Note that Dymola (as of version 2023.x) does not support a direct binding 
with a record function and requires a local instance of the record as illustrated
in this model.
</li>
</ul>
</html>"));
end BoilerHotWaterRecord;
