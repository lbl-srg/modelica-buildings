within Buildings.Applications.DHC.EnergyTransferStations.Control;
model EvaporatorCondenserPumpsController
  "The control block of the condenser and the evaporator water pumps"
     extends Modelica.Blocks.Icons.Block;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mCon(final displayUnit="kg/s")
    "Water mass flow rate of the condenser"
     annotation (Placement(
        transformation(extent={{-120,108},{-100,128}}), iconTransformation(
          extent={{-116,76},{-100,92}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEva(final displayUnit="kg/s")
    "Water mass flow rate of the evaporator"
     annotation (Placement(
        transformation(extent={{-118,-90},{-98,-70}}),  iconTransformation(
          extent={{-116,-88},{-100,-72}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput minConMasFlo(final displayUnit="kg/s")
    "Minimum mass flow rate of the heatpump at the condenser side set by the manufacturer"
     annotation (Placement(transformation(extent={{-120,132},{-100,152}}),
        iconTransformation(extent={{-116,-2},{-100,14}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput minEvaMasFlo(final displayUnit="kg/s")
   "Minimum mass flow rate of the heatpump at the evaporator side set by the manufacturer"
     annotation (Placement(transformation(extent={{-124,-20},{-100,4}}),
        iconTransformation(extent={{-116,-18},{-100,-2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mSecHea(final displayUnit="kg/s")
    "Water mass flow rate at the secondary (building) hot side"
     annotation (Placement(transformation(extent={{-120,86},{-100,106}}),
        iconTransformation(extent={{-116,60},{-100,76}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mSecCoo(final displayUnit="kg/s")
    "Water mass flow rate at the secondary (building) cold side"
     annotation (Placement(transformation(extent={{-120,-42},{-100,-22}}),
        iconTransformation(extent={{-116,-76},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqCoo
   "Cooling is required Boolean signal"
     annotation (Placement(transformation(extent={{-128,0},{-100,28}}),
        iconTransformation(extent={{-128,-112},{-100,-84}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqHea
   "Heating is required Boolean signal"
     annotation (Placement(transformation(extent={{-128,26},{-100,54}}),
        iconTransformation(extent={{-128,86},{-100,114}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumCon
    "Condenser pump speed outlet signal"
     annotation (Placement(transformation(
          extent={{200,144},{232,176}}), iconTransformation(extent={{100,70},{120,
            90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumEva
    "Evaporator pump speed outlet signal"
     annotation (Placement(transformation(
          extent={{200,-96},{232,-64}}), iconTransformation(extent={{100,-90},{120,
            -70}})));
  Buildings.Controls.Continuous.LimPID pumCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0.1,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0.1,
    k=1,
    Ti(displayUnit="s") = 300)
  "Controller for controller pump speed"
    annotation (Placement(transformation(extent={{8,126},{28,146}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant shuOffSig(k=0)
  "HeatPump, condenser pump  and evaporator pump shut off signal =0"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max2
    annotation (Placement(transformation(extent={{60,140},{80,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{-68,80},{-48,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1.1)
  "10% constant extra flow to maintain the primary higher than the secondary flow rate"
    annotation (Placement(transformation(extent={{-96,60},{-76,80}})));
  Buildings.Controls.Continuous.LimPID pumEva(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0.1,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0.1,
    k=1,
    Ti(displayUnit="s") = 300)
   "Controller for evaporator pump speed"
    annotation (Placement(transformation(extent={{24,-52},{44,-32}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1
    annotation (Placement(transformation(extent={{-64,-48},{-44,-28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=1.1)
  "10% constant extra flow to maintain the primary higher than the secondary flow rate"
    annotation (Placement(transformation(extent={{-94,-62},{-74,-42}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    annotation (Placement(transformation(extent={{-38,146},{-18,126}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    annotation (Placement(transformation(extent={{-36,-4},{-16,-24}})));
equation

  connect(max1.y,pumEva. u_s)
    annotation (Line(points={{-14,-14},{-2,-14},{-2,
          -42},{22,-42}},                color={0,0,127}));
  connect(mCon,pumCon. u_m)
    annotation (Line(points={{-110,118},{18,118},{18,124}},
                                                          color={0,0,127}));
  connect(yPumEva,yPumEva)
    annotation (Line(points={{216,-80},{216,-80}}, color={0,0,127}));
  connect(reqHea, or2.u1)
    annotation (Line(
      points={{-114,40},{-78,40},{-78,30},{-42,30}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(reqCoo, or2.u2)
    annotation (Line(points={{-114,14},{-78,14},{-78,22},{
          -42,22}},   color={255,0,255},
      pattern=LinePattern.Dot));
  connect(or2.y,pumCon. trigger)
    annotation (Line(
      points={{-18,30},{10,30},{10,124}},
      color={255,0,255},
      thickness=0.5));
  connect(shuOffSig.y, swi1.u3)
    annotation (Line(
      points={{82,10},{90,10},{90,22},{118,22}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(or2.y, swi1.u2)
    annotation (Line(points={{-18,30},{118,30}},
                color={255,0,255}));
  connect(max2.y, swi1.u1)
    annotation (Line(points={{82,130},{88,130},{88,38},{118,38}},
                     color={0,0,127}));
  connect(yPumCon,yPumCon)
    annotation (Line(points={{216,160},{216,160}},
                                                 color={0,0,127}));
  connect(mSecHea, pro.u1)
    annotation (Line(points={{-110,96},{-70,96}}, color={0,0,127}));
  connect(pro.u2, con.y)
    annotation (Line(points={{-70,84},{-74,84},{-74,70}}, color={0,0,127}));
  connect(mSecCoo, pro1.u1)
    annotation (Line(points={{-110,-32},{-66,-32}}, color={0,0,127}));
  connect(pro1.u2, con1.y)
    annotation (Line(points={{-66,-44},{-72,-44},{-72,-52}}, color={0,0,127}));
  connect(mEva,pumEva. u_m)
    annotation (Line(points={{-108,-80},{34,-80},{34,-54}}, color={0,0,127}));
  connect(pumCon.u_s, max.y)
    annotation (Line(points={{6,136},{-16,136}},   color={0,0,127}));
  connect(pro.y, max.u1)
    annotation (Line(points={{-46,90},{-44,90},{-44,130},{
          -40,130}}, color={0,0,127}));
  connect(minConMasFlo, max.u2)
    annotation (Line(points={{-110,142},{-40,142}}, color={0,0,127}));
  connect(or2.y,pumEva. trigger)
    annotation (Line(
      points={{-18,30},{10,30},{10,-62},{26,-62},{26,-54}},
      color={255,0,255},
      thickness=0.5));
  connect(pro1.y, max1.u1)
    annotation (Line(points={{-42,-38},{-42,-20},{-38,-20}}, color={0,0,127}));
  connect(minEvaMasFlo, max1.u2)
    annotation (Line(points={{-112,-8},{-38,-8}}, color={0,0,127}));
  connect(pumEva.y, max2.u1)
    annotation (Line(points={{45,-42},{54,-42},{54,124},
          {58,124}}, color={0,0,127}));
  connect(pumCon.y, max2.u2)
    annotation (Line(points={{29,136},{58,136}},
                     color={0,0,127}));
  connect(swi1.y,yPumCon)
    annotation (Line(points={{142,30},{158,30},{158,160},{216,160}},
        color={0,0,127}));
  connect(swi1.y,yPumEva)
    annotation (Line(points={{142,30},{158,30},{158,-80},{216,-80}},
        color={0,0,127}));
  annotation (defaultComponentName="pumCon",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,180}}),
        graphics={
        Rectangle(
          extent={{-98,2},{200,-100}},
          lineColor={255,0,255},
          pattern=LinePattern.Dot,
          fillColor={189,223,202},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,182},{200,50}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={223,223,223},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{90,178},{194,170}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={223,223,223},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="Condenser side water pump"),
        Text(
          extent={{92,-88},{196,-96}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={223,223,223},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="Evaporator side water pump")}),
          Documentation(info="<html>
<p>
The applied pumping configuration is variable flow primary-secondary systems. The primary
<code>pumEva</code> and <code>pumCon</code> pumps are interlocked and controlled to satisfiy
the thermal requirments at the building(secondary) side considering the following
</p>
<ul>
<li>
The mass flow rate of the primary pumps is 10% higher than the secondary pumps to avoid
the cross circulation through the hot and cold buffer tanks form the secondary side i.e. the return water
from the secondary side is mixed with the supply water.
<p align=\"center\">
<img alt=\"Image BufferTankCrossCirculation\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/BufferTankCrossCirculation.png\"/>
</p>
</li>
<li>
Maintain the heat pump flow rate between the minimum and maximum limit of the heat pump as advised by the manufacturer.
</li>
<li>
Maintain the hydraulic balance between the primary <code>pumEva</code>, <code>pumCon</code>
, borefield pump <code>pumBor</code> and distrcit heat exchanger pump <code>pumDis</code>
once the system is switched to reject heat to district network mode.
</li>
</ul>
<p>
The PI reverse action loop outputs the evaporator and condesner sides pumps rotating speed, taking
real inputs of primary and secondary flow rates. Whilest, the Boolean inputs <code>reqHea</code> and
<code>reqCoo</code> are to turn on/off the pumps.
</p>

</html>", revisions="<html>
<ul>
<li>
 <br/>
</li>
</ul>
</html>"));
end EvaporatorCondenserPumpsController;
