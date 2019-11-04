within Buildings.Applications.DHC.EnergyTransferStations.Control;
model HeatPumpController "The control block of the heatpump on heating mode"
     extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput ReqHea
    "Heating is required Boolean signal"
    annotation (Placement(transformation(extent={{-128,62},{-100,90}}),
        iconTransformation(extent={{-128,76},{-100,104}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput ReqCoo
    "Cooling is required Boolean signal"
    annotation (Placement(transformation(extent={{-128,30},{-100,58}}),
        iconTransformation(extent={{-128,46},{-100,74}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHeaMin(final unit="K",
      displayUnit="degC")
    "Minimum setpoint for heating supply water to space loads" annotation (
      Placement(transformation(extent={{-128,-114},{-100,-86}}),
        iconTransformation(extent={{-120,-24},{-100,-4}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetCoo(final unit="K",
      displayUnit="degC")
    "Setpoint for cooling supply water to space loads"
       annotation (Placement(transformation(extent={{-128,
            -160},{-100,-132}}),
                     iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHeaMax(final unit="K",
      displayUnit="degC") "Maximum setpoint for heating water " annotation (
      Placement(transformation(extent={{-128,-230},{-100,-202}}),
        iconTransformation(extent={{-120,-48},{-100,-28}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetHea(final unit="K",
      displayUnit="degC") "Setpoint for heating supply water to space loads"
    annotation (Placement(transformation(extent={{-128,-76},{-100,-48}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{-46,42},{-26,62}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{2,42},{22,62}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaModHeaPum(k=1)
    "Heating mode signal for the heatpump =1"
    annotation (Placement(transformation(extent={{-46,72},{-26,92}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant shuOffSig(k=0)
    "HeatPump shut off signal =0"
    annotation (Placement(transformation(extent={{-46,16},{-26,36}})));
  Modelica.Blocks.Math.RealToInteger realToInteger
    annotation (Placement(transformation(extent={{58,42},{78,62}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaPumMod
    "Heatpump operational mode"
    annotation (Placement(transformation(extent={{102,42},
            {122,62}}),iconTransformation(extent={{100,-14},{128,14}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetHeaPum(final unit="K",
      displayUnit="degC") "Setpoint temperture for the heatpump"
       annotation (Placement(transformation(extent={{102,-68},{122,-48}}),
        iconTransformation(extent={{100,28},{128,56}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaLvg(final unit="K", displayUnit=
        "degC") "Evaporator side leaving water temperature"
    annotation (Placement(transformation(extent={{-128,-204},{-100,-176}}), iconTransformation(
          extent={{-120,-110},{-100,-90}})));
  Modelica.Blocks.Logical.And simHeaCoo "Simultaneous heating and cooling mode"
    annotation (Placement(transformation(extent={{-86,-38},{-66,-18}})));
  Buildings.Controls.Continuous.LimPID PI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.05,
    Ti(displayUnit="s") = 300,
    reverseAction=true)
    "Resetting of heating set point tempearture in case reqCoo or (reqCoo and reqHea) are true."
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun
    "Mapping control function to reset the TsetHea"
    annotation (Placement(transformation(extent={{38,-150},{58,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X1(k=0)
    "PI minimum error"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X2(k=1)
    "PI maximum error"
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-8,-36},{12,-16}})));
  Modelica.Blocks.Logical.And heaOnl "Heating only mode"
    annotation (Placement(transformation(extent={{34,-16},{54,4}})));
equation

  connect(ReqCoo, or1.u2)
    annotation (Line(points={{-114,44},{-48,44}}, color={255,0,255}));
  connect(ReqHea, or1.u1)
    annotation (Line(points={{-114,76},{-56,76},{-56,52},{-48,52}},
                     color={255,0,255}));
  connect(or1.y, swi1.u2)
    annotation (Line(points={{-25,52},{0,52}},  color={255,0,255}));
  connect(swi1.u1, heaModHeaPum.y)
    annotation (Line(points={{0,60},{-16,60},{-16,82},{-24,82}},
                             color={0,0,127}));
  connect(swi1.u3, shuOffSig.y)
    annotation (Line(points={{0,44},{-16,44},{-16,26},{-24,26}},
                         color={0,0,127}));
  connect(realToInteger.y, yHeaPumMod)
    annotation (Line(points={{79,52},{112,52}}, color={255,127,0}));
  connect(swi1.y, realToInteger.u)
    annotation (Line(points={{24,52},{56,52}}, color={0,0,127}));
  connect(swi2.y, TSetHeaPum)
    annotation (Line(points={{92,-60},{104,-60},{104,-58},{112,-58}},
                                                  color={0,0,127}));
  connect(ReqCoo, simHeaCoo.u2) annotation (Line(points={{-114,44},{-96,44},{-96,-36},{-88,-36}},
                               color={255,0,255}));
  connect(ReqHea, simHeaCoo.u1) annotation (Line(points={{-114,76},{-92,76},{
          -92,-28},{-88,-28}}, color={255,0,255}));
  connect(PI.u_s, TSetCoo)
    annotation (Line(points={{-42,-170},{-78,-170},{-78,-146},{-114,-146}},
                                                    color={0,0,127}));
  connect(ReqCoo, PI.trigger) annotation (Line(points={{-114,44},{-96,44},{-96,-184},{-42,-184},
          {-42,-182},{-38,-182}}, color={255,0,255}));
  connect(X1.y, mapFun.x1) annotation (Line(points={{22,-110},{22,-132},{36,-132}},
                      color={0,0,127}));
  connect(PI.y, mapFun.u)
    annotation (Line(points={{-19,-170},{-12,-170},{-12,-140},{36,-140}},
                                                   color={0,0,127}));
  connect(TSetHeaMax, mapFun.f2) annotation (Line(points={{-114,-216},{26,-216},
          {26,-148},{36,-148}}, color={0,0,127}));
  connect(X2.y, mapFun.x2) annotation (Line(points={{22,-170},{22,-144},{36,-144}},
                      color={0,0,127}));
  connect(simHeaCoo.y, swi4.u2) annotation (Line(points={{-65,-28},{-54,-28},{-54,
          -110},{-42,-110}},  color={255,0,255}));
  connect(TSetHea, swi4.u1)
    annotation (Line(points={{-114,-62},{-62,-62},{-62,-102},{-42,-102}},
                                                   color={0,0,127}));
  connect(TSetHea, swi2.u1) annotation (Line(points={{-114,-62},{-88,-62},{-88,-52},
          {68,-52}},      color={0,0,127}));
  connect(swi4.y, mapFun.f1) annotation (Line(points={{-18,-110},{-12,-110},{-12,
          -136},{36,-136}}, color={0,0,127}));
  connect(TSetHeaMin, swi4.u3) annotation (Line(points={{-114,-100},{-68,-100},{
          -68,-118},{-42,-118}}, color={0,0,127}));
  connect(mapFun.y, swi2.u3) annotation (Line(points={{60,-140},{66,-140},{66,-68},
          {68,-68}}, color={0,0,127}));
  connect(ReqHea, heaOnl.u1) annotation (Line(points={{-114,76},{-56,76},{-56,-6},
          {32,-6}}, color={255,0,255}));
  connect(ReqCoo, not1.u) annotation (Line(points={{-114,44},{-60,44},{-60,-26},{-10,-26}},
                      color={255,0,255}));
  connect(heaOnl.y, swi2.u2) annotation (Line(points={{55,-6},{62,-6},{62,-60},{
          68,-60}}, color={255,0,255}));
  connect(not1.y, heaOnl.u2) annotation (Line(points={{14,-26},{20,-26},{20,-14},
          {32,-14}}, color={255,0,255}));
  connect(TEvaLvg, PI.u_m) annotation (Line(points={{-114,-190},{-30,-190},{-30,
          -182}}, color={0,0,127}));
  annotation (defaultComponentName="heaPumCon",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},{100,
            100}}),
        graphics={
        Rectangle(
          extent={{-98,100},{102,18}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-14,106},{96,82}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.None,
          textString="Heatpump operational mode"),
        Text(
          extent={{-46,-224},{98,-242}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.None,
          textString="Reset of water setpoint temperature")}),
                Documentation(info="<html>
<p>
The block is applied for the reversible heat pump control. It outputs the heat pump status
and resets the water temperature setpoint input signal to the heat pump <code>TReSetHea</code> based on the operational mode.
</p>
<h4>Heat pump status</h4>
<p>
If either <code>reqHea</code> or <code>reqCoo</code> is true, the controller outputs the integer output
<code>yHeaPumMod</code> to switch on the heat pump, other wise it switches off. 
</p>
<h4>Modes of operation</h4> 
<ul>
<li> 
Heating-only mode, the leaving water form the heat pump condenser side tracks the heating set point<code>TSetHea</code>
and the leaving chilled water from the evaporator floats depending on the entering water temperature and flow rate.
</li>
<li> 
Simultaneous cooling and heating and cooling only modes, the control sequence resets the heating set point<code>TSetHeaPum</code> till the leaving chilled water temperature
from the evaporator side meets the cooling set point<code>TSetCoo</code> as shown below in the figure
</li>
</ul>
<p align=\"center\">
<img alt=\"Image PI controller to reset the TSetHea\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/resetTsetHea.png\"/>
</p> 
<p>
The required leverage in <code>TSetHea</code> is estimated by a reverse acting PI loop , with a reference set point of <code>TSetCoo</code>
and measured temperature value of <code>TSouLvg</code>. Hence, when the evaporator leaving water temperature is higher than <code>TSetCoo</code>, 
TSetHea is increased.
</p>
<p>
During the simultaneous cooling and heating mode, the minimum re-set value of <code>TReSetHea</code> is considered equal to
<code>TsetHea</code> to assure that heating loads are covered. However, in case of cooling only mode, the minimum re-set value is considered <code>TSetHeaMin</code>
i.e. minimum leaving water temperature from the condenser, in order to reduce the heat pump compressor lift and improve the COP. The control mapping function
is illustrated below
</p>
<p align=\"center\">
<img alt=\"Image Control Mapping function of resetting TsetHea\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/controlMappingFunction.png\"/>
</p>  
<p>
See <a href=\"Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a> for detailed description of the heat pump theory of operation.
</p>
</html>", revisions="<html>

<ul>
<li>
 <br/>
</li>
</ul>
</html>"));
end HeatPumpController;
