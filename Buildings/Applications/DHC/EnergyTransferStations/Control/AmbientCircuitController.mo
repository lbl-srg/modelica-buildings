within Buildings.Applications.DHC.EnergyTransferStations.Control;
model AmbientCircuitController
  "Generate control outputs for the ambient circuit model"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.TemperatureDifference dTHex
    "Temperature difference between entering and leaving water of district heat exchanger";
  parameter Modelica.Blocks.Types.SimpleController
    controllerType=Modelica.Blocks.Types.SimpleController.PI "Type of controller"
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
  parameter Real yMin = 0.1 "Minimum control output"
    annotation (Dialog(group="PID controller"));
  Modelica.Blocks.Interfaces.RealInput TEntCon(final unit="K")
    "Condenser entering water temperature "
     annotation (Placement(
        transformation(extent={{-260,78},{-220,118}}), iconTransformation(
          extent={{-120,72},{-100,92}})));
  Modelica.Blocks.Interfaces.RealInput TEntEva(final unit="K")
    "Evaporator entering water temperature "
    annotation (Placement(
        transformation(extent={{-260,38},{-220,78}}), iconTransformation(extent={{-120,48},
            {-100,68}})));
  Modelica.Blocks.Interfaces.RealInput TBorIn(final unit="K")
    "Water temperature at borfield inlet"
    annotation (Placement(transformation(
          extent={{-260,-56},{-220,-16}}), iconTransformation(extent={{-120,-30},
            {-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput TBorOut(final unit="K")
    "Water temperature at borfield outlet" annotation (Placement(transformation(
          extent={{-260,-8},{-220,32}}), iconTransformation(extent={{-120,-56},{
            -100,-36}})));
  Modelica.Blocks.Interfaces.RealInput TDisHexEnt(final unit="K")
    "District heat exchanger entering water temperature"
    annotation (Placement(transformation(extent={{-260,-240},{-220,-200}}), iconTransformation(extent={{-120,
            -86},{-100,-66}})));
  Modelica.Blocks.Interfaces.RealInput TDisHexLvg(final unit="K")
    "District heat exchanger leaving water temperature"
    annotation (Placement(
        transformation(extent={{-260,-276},{-220,-236}}), iconTransformation(
          extent={{-120,-110},{-100,-90}})));
  Modelica.Blocks.Interfaces.BooleanInput valHea "Heating load side valve control"
    annotation (Placement(transformation(extent={{-260,160},{-220,200}}),
        iconTransformation(extent={{-120,22},{-100,42}})));
  Modelica.Blocks.Interfaces.BooleanInput valCoo "Cooling load side valve control"
    annotation (Placement(transformation(extent={{-260,118},{-220,158}}),
        iconTransformation(extent={{-120,2},{-100,22}})));
  Modelica.Blocks.Interfaces.IntegerOutput ModInd "Mode index"
    annotation (Placement(transformation(extent={{220,-70},
            {240,-50}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput yPumHexDis(final unit="1")
    "Heat exchanger district system pump control"
    annotation (Placement(
        transformation(extent={{220,-198},{240,-178}}), iconTransformation(
          extent={{100,-44},{120,-24}})));
  Modelica.Blocks.Interfaces.RealOutput yPumBor(final unit="1")
    "Borefield pump control signal"
    annotation (Placement(transformation(extent=
           {{220,80},{240,100}}), iconTransformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.Continuous.LimPID hexPumCon(
    final k=k,
    final Ti=Ti,
    final Td=Td,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=yMin,
    reverseAction=true,
    yMin=yMin,
    final controllerType=controllerType)
    "Heat exchanger pump control"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(k2=-1)
    annotation (Placement(transformation(extent={{-160,-260},{-140,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs3
    annotation (Placement(transformation(extent={{-120,-260},{-100,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(k=dTHex)
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(k=0)
    annotation (Placement(transformation(extent={{20,-118},{40,-98}})));
  Buildings.Controls.OBC.CDL.Logical.Switch hexPumConOut
    "Heat exchnager pump control."
    annotation (Placement(transformation(extent={{160,-198},{180,-178}})));
  Buildings.Controls.OBC.CDL.Logical.Switch heaMod
    "Mode index"
    annotation (Placement(transformation(extent={{122,-70},{142,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(k=1)
    annotation (Placement(transformation(extent={{80,-42},{100,-22}})));
  Buildings.Controls.OBC.CDL.Logical.Switch cooModInd "Cooling mode index."
    annotation (Placement(transformation(extent={{82,-100},{102,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5(k=-1)
    annotation (Placement(transformation(extent={{20,-42},{40,-22}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{178,-70},{198,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or valOpe
    "True if hot or cold two way valve is open "
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.Continuous.LimPID geoPumCon(
    final Td=Td,
    reset=Buildings.Types.Reset.Parameter,
    reverseAction=true,
    y_reset=0,
    final k=1,
    yMin=0.5,
    final controllerType=controllerType,
    Ti(displayUnit="min") = 3600)
    "Geothermal pump control"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch runBorPum
    "Switch that enable borefield pump"
    annotation (Placement(transformation(extent={{182,80},{202,100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch modSwi1
    "Rejection heat mode switch:heating"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch modSwi2
    "Rejection heat mode switch:cooling"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant avgBorTem(k=15 + 273.15)
    "Average borefiled water temperature"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Logical.And runBorPum1
    "output true if either two way valves are open and deltaT at the borfield is larger than 0.5"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-46,-154},{-26,-134}})));
  Buildings.Controls.OBC.CDL.Logical.And runDisPum
    "output true if either two way valves are open and borefiled is totally charged"
    annotation (Placement(transformation(extent={{-4,-146},{16,-126}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=0.2, uHigh=1)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(valOpe.y, runDisPum.u1) annotation (Line(points={{-158,170},{-16,170},
          {-16,-136},{-6,-136}}, color={255,0,255}));
  connect(add4.y, abs3.u)
    annotation (Line(points={{-138,-250},{-122,-250}}, color={0,0,127}));
  connect(abs3.y,hexPumCon. u_m)
   annotation (Line(points={{-98,-250},{90,-250},{90,-192}},
                       color={0,0,127}));
  connect(con3.y,hexPumCon. u_s)
    annotation (Line(points={{22,-180},{78,-180}},   color={0,0,127}));
  connect(TDisHexEnt, add4.u1)
    annotation (Line(points={{-240,-220},{-200,-220},{-200,-244},{-162,-244}}, color={0,0,127}));
  connect(TDisHexLvg, add4.u2)
    annotation (Line(points={{-240,-256},{-162,-256}}, color={0,0,127}));
  connect(con2.y,heaMod. u1)
    annotation (Line(points={{102,-32},{110,-32},{110,-52},{120,-52}},
                                                  color={0,0,127}));
  connect(con5.y, cooModInd.u1) annotation (Line(points={{42,-32},{70,-32},{70,-82},
          {80,-82}},      color={0,0,127}));
  connect(con4.y, cooModInd.u3) annotation (Line(points={{42,-108},{62,-108},{62,
          -98},{80,-98}},    color={0,0,127}));
  connect(reaToInt.y, ModInd) annotation (Line(points={{200,-60},{230,-60}}, color={255,127,0}));
  connect(hexPumConOut.u3, con4.y) annotation (Line(points={{158,-196},{60,-196},
          {60,-108},{42,-108}}, color={0,0,127}));
  connect(add1.y, abs1.u)
    annotation (Line(points={{-138,-30},{-122,-30}},
                                                color={0,0,127}));
  connect(hexPumConOut.u1, hexPumCon.y)
    annotation (Line(points={{158,-180},{101,-180}},
                                                  color={0,0,127}));
  connect(hexPumConOut.y, yPumHexDis)
    annotation (Line(points={{182,-188},{230,-188}}, color={0,0,127}));
  connect(runBorPum.y, yPumBor)
    annotation (Line(points={{204,90},{230,90}}, color={0,0,127}));
  connect(con4.y, runBorPum.u3) annotation (Line(points={{42,-108},{60,-108},{60,
          0},{174,0},{174,82},{180,82}},    color={0,0,127}));
  connect(valHea, valOpe.u1) annotation (Line(points={{-240,180},{-192,180},{-192,
          170},{-182,170}},      color={255,0,255}));
  connect(valCoo, valOpe.u2) annotation (Line(points={{-240,138},{-214,138},{-214,
          162},{-182,162}},      color={255,0,255}));
  connect(cooModInd.y, heaMod.u3) annotation (Line(points={{104,-90},{114,-90},{
          114,-68},{120,-68}},                    color={0,0,127}));
  connect(heaMod.y, reaToInt.u) annotation (Line(points={{144,-60},{176,-60}}, color={0,0,127}));
  connect(valHea, modSwi1.u2) annotation (Line(points={{-240,180},{-206,180},{-206,
          90},{-42,90}}, color={255,0,255}));
  connect(TEntCon, modSwi1.u1)
    annotation (Line(points={{-240,98},{-42,98}}, color={0,0,127}));
  connect(modSwi1.u3, modSwi2.y) annotation (Line(points={{-42,82},{-46,82},{-46,
          50},{-58,50}}, color={0,0,127}));
  connect(valCoo,modSwi2. u2) annotation (Line(points={{-240,138},{-214,138},{-214,
          50},{-82,50}}, color={255,0,255}));
  connect(TEntEva,modSwi2. u1)
    annotation (Line(points={{-240,58},{-82,58}}, color={0,0,127}));
  connect(modSwi1.y, geoPumCon.u_s) annotation (Line(points={{-18,90},{0,90},{0,
          140},{18,140}}, color={0,0,127}));
  connect(valOpe.y, geoPumCon.trigger) annotation (Line(points={{-158,170},{-148,
          170},{-148,118},{22,118},{22,128}}, color={255,0,255}));
  connect(TBorOut, geoPumCon.u_m)
    annotation (Line(points={{-240,12},{30,12},{30,128}}, color={0,0,127}));
  connect(modSwi2.u3, avgBorTem.y) annotation (Line(points={{-82,42},{-100,42},{
          -100,30},{-118,30}}, color={0,0,127}));
  connect(geoPumCon.y, runBorPum.u1) annotation (Line(points={{41,140},{174,140},
          {174,98},{180,98}}, color={0,0,127}));
  connect(TBorOut, add1.u1) annotation (Line(points={{-240,12},{-200,12},{-200,-24},
          {-162,-24}}, color={0,0,127}));
  connect(TBorIn, add1.u2) annotation (Line(points={{-240,-36},{-162,-36}},
                            color={0,0,127}));
  connect(valOpe.y, runBorPum1.u1)
    annotation (Line(points={{-158,170},{58,170}}, color={255,0,255}));
  connect(runBorPum1.y, runBorPum.u2) annotation (Line(points={{82,170},{146,170},
          {146,90},{180,90}}, color={255,0,255}));
  connect(runDisPum.u2, not1.y)
    annotation (Line(points={{-6,-144},{-24,-144}}, color={255,0,255}));
  connect(runDisPum.y, hexPumConOut.u2) annotation (Line(points={{18,-136},{140,
          -136},{140,-188},{158,-188}}, color={255,0,255}));
  connect(runDisPum.y, hexPumCon.trigger) annotation (Line(points={{18,-136},{40,
          -136},{40,-222},{82,-222},{82,-192}}, color={255,0,255}));
  connect(valHea, heaMod.u2) annotation (Line(
      points={{-240,180},{-206,180},{-206,-84},{-44,-84},{-44,-60},{120,-60}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(valCoo, cooModInd.u2) annotation (Line(
      points={{-240,138},{-214,138},{-214,-90},{80,-90}},
      color={255,0,255},
      pattern=LinePattern.Dot));
  connect(abs1.y, hysteresis.u)
    annotation (Line(points={{-98,-30},{-82,-30}}, color={0,0,127}));
  connect(hysteresis.y, runBorPum1.u2) annotation (Line(points={{-59,-30},{-4,-30},
          {-4,162},{58,162}}, color={255,0,255}));
  connect(hysteresis.y, not1.u) annotation (Line(points={{-59,-30},{-52,-30},{-52,
          -144},{-48,-144}}, color={255,0,255}));

  annotation (Diagram(  coordinateSystem( extent={{-220,-280},{220,200}}, preserveAspectRatio=false),
                        Icon(coordinateSystem(initialScale=1)),
                        graphics={Text(
                        extent={{382,176},{198,140}},
                        lineColor={28,108,200},
                        textString="PI with large time constant because of long time constant
                                    of borefield.yMin=0.5 to stay turbulent")}),
                        defaultComponentName="AmbCirCon",
                        Documentation(info="<html>
<h4> Ambient circuit controller theory of operation </h4>
<p>
This block computes the output signals to turn on and off the borefield, the heat exchanger district circuit pumps, and also
it computes the output integer <code>ModInd</code> which indicates the energy rejection index, i.e. heating or cooling energy is rejected.
The controller includes two operational modes
</p>
<h4>Reject to borefield system</h4>
<p>
The controller computes the real signal <code>yPumBor</code> to turn on and off the pump,
if either the Boolean signal of the two way valve status <code>valHea</code> or <code>valCoo</code> is true
and the difference between <CODE>TBorIn</code> and <CODE>TBorIn</code> is &#8807;1&deg;C.
In addition, the controller modulates the <code>pumBor</code> speed, by a reverse acting PI loop with
a setpoint temperature <code>TConEnt</code> or<code>TConEnt</code> depending on the rejection heat mode and
and the outlet water from the borefield <code>TBorOut</code>.
</p>
<h4>Reject to the district heat exchanger system</h4>
<p>
In order to maximize overall system exergy, the heat rejection to the heat exchanger system stars only when  the borefiled is charged.
</p>
<p>
The controller turns on heat exchanger district pump <code>pumHexDis</code> if either
the Boolean signal of the two way valve status <code>valHea</code> or <code>valCoo</code> is true and
&Delta;(TBorOut-TBorIn) is &#8806;1&deg;C.
</p>
<p>
Accordingly, the reverse acting PI loop modulates
the <code>pumHexDis</code> pump speed to maintain the difference between
entering and leaving water temperature of the district heat exchanger <code>TDisHexEnt</code> and
<code>TDisHexLvg</code> equals to <code>dTHex</code>.
</p>
<h4> The energy rejection mode index </h4>
<p>
The controller computes the energy rejection mode <code>ModInd</code> to either the borfield or district heat exchanger system.
Hence, the <code>ModInd</code> =1, if the thermal energy rejection occurs from heat pump condenser side,
and <code>ModInd</code> =-1, if it occurs from evaporator side.
</p>

</html>", revisions="<html>
<ul>
<li>
 <br/>
</li>
</ul>
</html>"));
end AmbientCircuitController;
