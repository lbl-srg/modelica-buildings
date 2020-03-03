within Buildings.Applications.DHC.EnergyTransferStations.Controls;
model AmbientCircuit "Ambient water circuit controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.TemperatureDifference dTGeo
    "Temperature difference between entering and leaving water to the borefield";
  parameter Modelica.SIunits.TemperatureDifference dTHex
    "Temperature difference  between entering and leaving water to the district heat exchanger";
  parameter Modelica.Blocks.Types.SimpleController
    controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k(final unit="1/K")=0.1
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.SIunits.Time Ti(min=0)=60
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PI
         or  controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PD
          or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMin = 0.1
  "Minimum control output"
    annotation (Dialog(group="PID controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBorEnt(
    final unit="K", displayUnit="degc")
    "Borefield entering water temperature "
    annotation (Placement(transformation(extent={{-260,-52},{-220,-12}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBorLvg(
    final unit="K",displayUnit="degc")
    "Borefield leaving water temperature"
    annotation (Placement(transformation(extent={{-260,-80},{-220,-40}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBorMaxEnt(
    final unit="K",displayUnit="degc")
    "Maximum entering water temperature to the borefiled holes."
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisHexEnt(
    final unit="K", displayUnit="degc")
    "District heat exchanger entering water temperature"
    annotation (Placement(transformation(extent={{-260,-300},{-220,-260}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisHexLvg(
    final unit="K", displayUnit="degc")
    "District heat exchanger leaving water temperature"
    annotation (Placement(transformation(extent={{-260,-340},{-220,-300}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput valHea
    "Heating load side valve control"
    annotation (Placement(transformation(extent={{-260,230},{-220,270}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput valCoo
    "Cooling load side valve control"
    annotation (Placement(transformation(extent={{-260,200},{-220,240}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqHea
    "True if heating is required"
    annotation (Placement(transformation(extent={{-260,170},{-220,210}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reqCoo
  "True if cooling is required"
    annotation (Placement(transformation(extent={{-260,138},{-220,178}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBorThrVal(final unit="1")
    "Control signal for the borefiled three-way mixing valve"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
        iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDisHexPum(final unit="1")
    "District heat exchanger pump control"
    annotation (Placement(transformation(extent={{220,-300},{260,-260}}),
      iconTransformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBorPum(final unit="1")
    "Borefield system pump control"
    annotation (Placement(transformation(extent={{220,-58},{260,-18}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput modRej
    "Surplus heat or cold rejection mode" annotation (Placement(transformation(
          extent={{220,-240},{260,-200}}), iconTransformation(extent={{100,-10},
            {120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput rejCooFulLoa
    "True if cold side requires full surplus cold rejection"
    annotation (Placement(transformation(extent={{-260,-260},{-220,-220}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput rejHeaFulLoa
    "True if hot side requires full surplus heat rejection"
    annotation (Placement(transformation(extent={{-262,-198},{-222,-158}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.Continuous.LimPID hexPumCon(
    final k=k,
    final Ti=Ti,
    final Td=Td,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=yMin,
    reverseAction=true,
    yMin=yMin,
    final controllerType=controllerType)
    "District heat exchanger pump control"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(k2=-1)
    annotation (Placement(transformation(extent={{-160,-330},{-140,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs3
    annotation (Placement(transformation(extent={{-120,-330},{-100,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(k=dTHex)
    "Difference between the district heat exchanger leaving and entering water temperature(+ve)."
    annotation (Placement(transformation(extent={{-80,-272},{-60,-252}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(k=0)
    annotation (Placement(transformation(extent={{20,-208},{40,-188}})));
  Buildings.Controls.OBC.CDL.Logical.Switch hexPumConOut
  "District heat exchanger pump control"
    annotation (Placement(transformation(extent={{100,-290},{120,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Switch indMod
  "Mode index"
    annotation (Placement(transformation(extent={{120,-148},{140,-128}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(k=1)
    annotation (Placement(transformation(extent={{80,-126},{100,-106}})));
  Buildings.Controls.OBC.CDL.Logical.Switch indCooMod
  "Cooling mode index"
    annotation (Placement(transformation(extent={{82,-188},{102,-168}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5(k=-1)
    annotation (Placement(transformation(extent={{20,-126},{40,-106}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{180,-230},{200,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Or valOpe
    annotation (Placement(transformation(extent={{-180,230},{-160,250}})));
  Buildings.Controls.OBC.CDL.Logical.Or  runHex
    "Output true if the heat exchanger of the substation needs to run"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Not noHex
    annotation (Placement(transformation(extent={{-60,-302},{-40,-282}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd opeHea(nu=2)
    "Heating is required and heat rejection is from cold tank."
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd opeCol(nu=2)
    "Cooling is required and heat rejection is from hot tank."
    annotation (Placement(transformation(extent={{-112,152},{-92,172}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 runBorFie
    "Output true if borefield must run"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch modInd1
  "Mode index"
    annotation (Placement(transformation(extent={{160,-168},{180,-148}})));
  Buildings.Controls.OBC.CDL.Logical.Switch modInd2
  "Mode index"
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-40,-92},{-20,-72}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    annotation (Placement(transformation(extent={{0,-92},{20,-72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=dTGeo)
    "Difference between the borfield leaving and entering water temperature(+ve)."
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.Continuous.LimPID conPumBor(
    final Td=Td,
    reset=Buildings.Types.Reset.Parameter,
    reverseAction=true,
    y_reset=0,
    final k=1,
    yMin=0.5,
    final controllerType=controllerType,
    Ti(displayUnit="s") = 3600) "Borefield pump controller"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Logical.Or runFulLoa
    "Output true if borefield needs to run at full load to reject heat"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch modInd3 "Mode index"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch runBor
    "Switch that enable the borefield system pump"
    annotation (Placement(transformation(extent={{190,-50},{210,-30}})));
  Buildings.Controls.Continuous.LimPID borThrWay(
    final Td=Td,
    reset=Buildings.Types.Reset.Parameter,
    reverseAction=false,
    y_reset=0,
    final k=1,
    yMin=0.1,
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti(displayUnit="min") = 3600)
    "3-way valve controls the entering water temperature to the borefield holes"
    annotation (Placement(transformation(extent={{-106,-10},{-86,10}})));

equation
  connect(add4.y, abs3.u)  annotation (Line(points={{-138,-320},{-122,-320}}, color={0,0,127}));
  connect(abs3.y,hexPumCon. u_m) annotation (Line(points={{-98,-320},{-10,-320},
          {-10,-292}}, color={0,0,127}));
  connect(con3.y,hexPumCon. u_s) annotation (Line(points={{-58,-262},{-40,-262},
          {-40,-280},{-22,-280}},                                                 color={0,0,127}));
  connect(TDisHexEnt, add4.u1) annotation (Line(points={{-240,-280},{-200,-280},
          {-200,-314},{-162,-314}}, color={0,0,127}));
  connect(TDisHexLvg, add4.u2)  annotation (Line(points={{-240,-320},{-202,-320},
          {-202,-326},{-162,-326}}, color={0,0,127}));
  connect(con2.y,indMod. u1)  annotation (Line(points={{102,-116},{110,-116},{110,-130},{118,-130}},
                                                  color={0,0,127}));
  connect(con5.y,indCooMod. u1) annotation (Line(points={{42,-116},{70,-116},{
          70,-170},{80,-170}},
                          color={0,0,127}));
  connect(con4.y,indCooMod. u3) annotation (Line(points={{42,-198},{60,-198},{
          60,-186},{80,-186}},
                             color={0,0,127}));
  connect(reaToInt.y, modRej)
    annotation (Line(points={{202,-220},{240,-220}}, color={255,127,0}));
  connect(valHea, valOpe.u1) annotation (Line(points={{-240,250},{-200,250},{-200,
          240},{-182,240}}, color={255,0,255}));
  connect(valCoo, valOpe.u2) annotation (Line(points={{-240,220},{-200,220},{-200,
          232},{-182,232}}, color={255,0,255}));
  connect(noHex.y,hexPumCon. trigger) annotation (Line(points={{-38,-292},{-18,-292}},
                                                   color={255,0,255}));
  connect(valOpe.y, opeHea.u[1]) annotation (Line(points={{-158,240},{-140,240},
          {-140,193.5},{-122,193.5}}, color={255,0,255}));
  connect(reqHea, opeHea.u[2]) annotation (Line(points={{-240,190},{-164,190},{
          -164,186.5},{-122,186.5}}, color={255,0,255}));
  connect(indMod.u2, opeHea.y) annotation (Line(points={{118,-138},{-60,-138},{
          -60,190},{-98,190}},   color={255,0,255}));
  connect(opeCol.u[1], valOpe.y) annotation (Line(points={{-114,165.5},{-140,
          165.5},{-140,240},{-158,240}}, color={255,0,255}));
  connect(opeCol.u[2], reqCoo) annotation (Line(points={{-114,158.5},{-164,
          158.5},{-164,158},{-240,158}}, color={255,0,255}));
  connect(indCooMod.u2, opeCol.y) annotation (Line(points={{80,-178},{-80,-178},
          {-80,162},{-90,162}}, color={255,0,255}));
  connect(hexPumConOut.u3, con4.y) annotation (Line(points={{98,-288},{60,-288},
          {60,-198},{42,-198}}, color={0,0,127}));
  connect(runBorFie.u3, or3.y) annotation (Line(points={{78,102},{60,102},{60,
          90},{-18,90}},     color={255,0,255}));
  connect(runBorFie.u2,rejCooFulLoa)  annotation (Line(points={{78,110},{-200,110},
          {-200,-240},{-240,-240}},      color={255,0,255}));
  connect(runBorFie.u1, rejHeaFulLoa) annotation (Line(points={{78,118},{-208,118},
          {-208,-178},{-242,-178}},      color={255,0,255}));
  connect(or3.u1, opeHea.y) annotation (Line(points={{-42,90},{-60,90},{-60,190},
          {-98,190}},  color={255,0,255}));
  connect(or3.u2, opeCol.y) annotation (Line(points={{-42,82},{-80,82},{-80,162},
          {-90,162}},  color={255,0,255}));
  connect(indMod.u3, con4.y) annotation (Line(points={{118,-146},{60,-146},{60,
          -198},{42,-198}},
                          color={0,0,127}));
  connect(indMod.y, modInd1.u1) annotation (Line(points={{142,-138},{150,-138},{150,-150},{158,-150}},
                                                             color={0,0,127}));
  connect(modInd1.u2, opeHea.y) annotation (Line(points={{158,-158},{-60,-158},
          {-60,190},{-98,190}},
                             color={255,0,255}));
  connect(indCooMod.y, modInd1.u3) annotation (Line(points={{104,-178},{150,
          -178},{150,-166},{158,-166}},
                                color={0,0,127}));
  connect(modInd1.y, modInd2.u1) annotation (Line(points={{182,-158},{200,-158},
          {200,-194},{100,-194},{100,-212},{118,-212}},
                                                     color={0,0,127}));
  connect(modInd2.u3, con4.y) annotation (Line(points={{118,-228},{60,-228},{60,
          -198},{42,-198}},
                          color={0,0,127}));
  connect(reaToInt.u, modInd2.y) annotation (Line(points={{178,-220},{142,-220}},
                                  color={0,0,127}));
  connect(add1.y, abs1.u) annotation (Line(points={{-18,-82},{-2,-82}},
                                                color={0,0,127}));
  connect(runBorFie.y, not2.u) annotation (Line(points={{102,110},{118,110}}, color={255,0,255}));
  connect(con1.y,conPumBor. u_s) annotation (Line(points={{62,-50},{78,-50}},color={0,0,127}));
  connect(abs1.y,conPumBor. u_m) annotation (Line(points={{22,-82},{90,-82},{90,-62}},
                                                       color={0,0,127}));
  connect(not2.y,conPumBor. trigger) annotation (Line(points={{142,110},{150,
          110},{150,-6},{72,-6},{72,-70},{82,-70},{82,-62}},
                                                          color={255,0,255}));
  connect(runFulLoa.u1, rejHeaFulLoa) annotation (Line(points={{-182,-180},{-212,
          -180},{-212,-178},{-242,-178}},color={255,0,255}));
  connect(runFulLoa.u2,rejCooFulLoa)  annotation (Line(points={{-182,-188},{-200,
          -188},{-200,-240},{-240,-240}},color={255,0,255}));
  connect(conPumBor.y, modInd3.u3)  annotation (Line(points={{101,-50},{120,-50},
          {120,-48},{138,-48}},                  color={0,0,127}));
  connect(modInd3.u2, runFulLoa.y) annotation (Line(points={{138,-40},{132,-40},
          {132,-96},{-150,-96},{-150,-180},{-158,-180}},
                                                    color={255,0,255}));
  connect(modInd3.u1, con2.y) annotation (Line(points={{138,-32},{120,-32},{120,
          -116},{102,-116}},
                           color={0,0,127}));
  connect(hexPumConOut.u1, hexPumCon.y) annotation (Line(points={{98,-272},{50,-272},
          {50,-280},{1,-280}},                    color={0,0,127}));
  connect(runBor.y,yBorPum) annotation (Line(points={{212,-40},{222,-40},{222,
          -38},{240,-38}},                       color={0,0,127}));
  connect(modInd3.y,runBor. u1) annotation (Line(points={{162,-40},{174,-40},{
          174,-32},{188,-32}},
                         color={0,0,127}));
  connect(valOpe.y,runBor. u2) annotation (Line(points={{-158,240},{180,240},{
          180,-40},{188,-40}},
                             color={255,0,255}));
  connect(con4.y,runBor. u3) annotation (Line(points={{42,-198},{60,-198},{60,
          -92},{174,-92},{174,-48},{188,-48}},
                                      color={0,0,127}));
  connect(TBorMaxEnt, borThrWay.u_s)  annotation (Line(points={{-240,0},{-108,0}}, color={0,0,127}));
  connect(borThrWay.y, yBorThrVal) annotation (Line(points={{-85,0},{240,0}}, color={0,0,127}));
  connect(not2.y, borThrWay.trigger) annotation (Line(points={{142,110},{150,
          110},{150,-6},{72,-6},{72,-26},{-104,-26},{-104,-12}}, color={255,0,
          255}));
  connect(TBorEnt, borThrWay.u_m) annotation (Line(points={{-240,-32},{-96,-32},
          {-96,-12}}, color={0,0,127}));
  connect(TBorLvg, add1.u2) annotation (Line(points={{-240,-60},{-142,-60},{
          -142,-88},{-42,-88}}, color={0,0,127}));
  connect(TBorEnt, add1.u1) annotation (Line(points={{-240,-32},{-96,-32},{-96,
          -76},{-42,-76}}, color={0,0,127}));
  connect(hexPumConOut.y, yDisHexPum) annotation (Line(points={{122,-280},{240,
          -280}},                                                                      color={0,0,127}));
  connect(rejHeaFulLoa, runHex.u1) annotation (Line(points={{-242,-178},{-208,-178},
          {-208,-220},{-182,-220}},       color={255,0,255}));
  connect(rejCooFulLoa, runHex.u2) annotation (Line(points={{-240,-240},{-200,-240},
          {-200,-228},{-182,-228}},       color={255,0,255}));
  connect(runHex.y, modInd2.u2) annotation (Line(points={{-158,-220},{-18,-220},
          {-18,-220},{118,-220}}, color={255,0,255}));
  connect(runHex.y, hexPumConOut.u2) annotation (Line(points={{-158,-220},{42,-220},
          {42,-280},{98,-280}},       color={255,0,255}));
  connect(runHex.y, noHex.u) annotation (Line(points={{-158,-220},{-90,-220},{
          -90,-292},{-62,-292}}, color={255,0,255}));

annotation (Diagram(
              coordinateSystem(preserveAspectRatio=false,
              extent={{-220,-340},{220,260}})),
              defaultComponentName="ambCirCon",
Documentation(info="<html>
<h4> Ambient circuit controller theory of operation </h4>
<p>
This block computes the output integer <code>ModInd</code> which indicates the energy 
rejection index, i.e. heating or cooling energy is rejected and the control signals to turn
on/off and modulates the followings
</p>
<h4>Borfield pump</h4>
<p>
The borfield pump <code>pumBor</code> is variable speed pump, the flow rate is modulated
using a reverse acting PI loop with a reference &Delta;<code>dTBor</code> and the absolute
measured temperatue difference between the <code>TBorEnt</code> and <code>TDisHexEnt</code>.
The controller in addition switches between modulating the <code>pumBor</code> flow rate or
run on maximum flow rate <code>rejFulLoa</code> is true.
</p>
<h4>Three way valve at borefield inlet</h4>
<p>
The three way valve at the inlet stream of the borfield system is controlled with 
a P or PI controller to track a constant, minimum borfield  water inlet temperature.
</p>
<h4>Heat exchanger district pump</h4>
<p>
The exchanger district <code>pumHexDis</code> is a variable speed pump. It turns on if either
the Boolean signal of the two way valve status <code>valHea</code> or <code>valCoo</code> and
<code>rejFulLoa</code> are true, and the flow rate is modulated using a reverse acting PI loop
to maintain the absolute measured temperature difference between <code>TDisHexEnt</code> and
<code>TDisHexLvg</code> equals to &Delta;<code>dTHex</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2020, by Hagar Elarga:<br/>
Updated the heat exchanger pump controller to operate only if reject full load signal
is true.
</li>
<li>
November 2, 2019, by Hagar Elarga:<br/>
Added the three way valve controller and the documentation.
</li>

</ul>
</html>"));
end AmbientCircuit;
