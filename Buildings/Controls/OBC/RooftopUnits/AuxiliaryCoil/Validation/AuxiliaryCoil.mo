within Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.Validation;
model AuxiliaryCoil
  "Validation model of auxiliary heating coil control sequence"

  Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.AuxiliaryCoil conAuxCoi(
    final nCoi=2,
    final TLocOut=273.15 - 12.2,
    final dTHys=273.1,
    final uThrHeaCoi=0.9,
    final dUHys=0.01)
    "Instance of controller for auxiliary heating coil with DX coil lockout"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil.AuxiliaryCoil conAuxCoi1(
    final nCoi=2,
    final TLocOut=273.15 - 12.2,
    final dTHys=273.1,
    final uThrHeaCoi=0.9,
    final dUHys=0.01)
    "Instance of controller for auxiliary heating coil without DX coil lockout"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k={true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp HeaCoi(
    final height=1,
    final offset=0,
    final duration=1200)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(
    final k=273.15 - 15)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[2](
    final k={true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut1(
    final k=273.15 + 5)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp HeaCoi1(
    final height=1,
    final offset=0,
    final duration=1200)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

equation
  connect(conAuxCoi.uHeaCoi, HeaCoi.y)
    annotation (Line(points={{18,44},{10,44},{10,20},{-18,20}}, color={0,0,127}));
  connect(TOut.y, conAuxCoi.TOut)
    annotation (Line(points={{-18,50},{18,50}},               color={0,0,127}));
  connect(TOut1.y, conAuxCoi1.TOut)
    annotation (Line(points={{-18,-50},{18,-50}},                 color={0,0,127}));
  connect(HeaCoi1.y, conAuxCoi1.uHeaCoi)
    annotation (Line(points={{-18,-80},{10,-80},{10,-56},{18,-56}},   color={0,0,127}));
  connect(con.y, conAuxCoi.uDXCoi) annotation (Line(points={{-18,80},{10,80},{10,
          56},{18,56}},     color={255,0,255}));
  connect(con1.y, conAuxCoi1.uDXCoi) annotation (Line(points={{-18,-20},{10,-20},
          {10,-44},{18,-44}}, color={255,0,255}));

  annotation (
    experiment(StopTime=1800, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/AuxiliaryCoil/Validation/AuxiliaryCoil.mos"
        "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Fluid.RooftopUnits.Controls.AuxiliaryCoil\">
    Buildings.Fluid.RooftopUnits.Controls.AuxiliaryCoil</a>.
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the outdoor air temperature <code>conAuxCoi.TOut</code> drops to <i>-15</i>&deg;C, 
    which is below the outdoor air lockout temperature <code>TLocOut</code> 
    (e.g., <i>-12.2</i>&deg;C), the controller deactivates DX coils 
    <code>conAuxCoi.yDXCoi=false</code> and utilizes the heating coil valve position 
    signal <code>conAuxCoi.uHeaCoi</code> as the auxiliary heating coil operation signal 
    <code>conAuxCoi.yAuxHea</code>.
    </li>
    <li>
    When <code>conAuxCoi1.TOut</code> reaches <i>5</i>&deg;C, which is above 
    <code>TLocOut</code> of <i>-12.2</i>&deg;C, and <code>conAuxCoi1.uHeaCoi</code> 
    exceeds a threshold <code>conAuxCoi1.uThrHeaCoi</code> of 0.9, the controller outputs 
    <code>conAuxCoi1.yAuxHea</code> based on the product of the P controller output 
    <code>conAuxCoi1.conPHeaHig.y</code> and the difference between 
    <code>conAuxCoi1.uHeaCoi</code> and the threshold <code>uThrHeaCoi</code> of 0.9. 
    Additionally, the controller outputs 0 when <code>conAuxCoi1.uHeaCoi</code> falls 
    below the threshold value.
    </li>
    </ul>
    </p>
    </html>",revisions="<html>
    <ul>
    <li>
    July 3, 2023, by Junke Wang and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end AuxiliaryCoil;
