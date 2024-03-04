within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints;
block HybridPlantEnable "Stages lag primary loop in hybrid boiler plant"

  final parameter Boolean have_priOnl = false
    "Is the boiler plant a primary-only, condensing boiler plant?"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  final parameter Integer nBoi = 2
    "Number of boilers"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  final parameter Integer boiTyp[nBoi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler}
    "Boiler type"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  final parameter Integer nSta = 2
    "Number of boiler plant stages"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  final parameter Integer staMat[nSta, nBoi] = {{1,0},{0,1}}
    "Staging matrix with stage as row index and boiler as column index"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  final parameter Real boiMinPriPumSpeSta[nSta](
    final unit=fill("1",nSta),
    displayUnit=fill("1",nSta),
    final max=fill(1,nSta),
    final min=fill(0,nSta)) = {0.5, 0.5}
    "Minimum primary pump speed for the boiler plant stage"
    annotation(Evaluate=true,
      Dialog(enable=not
                       (have_priOnl),
        tab="General",
        group="Boiler plant configuration parameters"));

  parameter Real avePer(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for the capacity requirement rolling average"
    annotation(Dialog(tab="Staging parameters", group="Capacity requirement calculation parameters"));

  parameter Real fraNonConBoi(
    final unit="1",
    displayUnit="1") = 0.9
    "Fraction of current stage design capacity at which efficiency condition is 
    satisfied for non-condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Efficiency condition parameters"));

  parameter Real fraConBoi(
    final unit="1",
    displayUnit="1") = 1.5
    "Fraction of higher stage design capacity at which efficiency condition is 
    satisfied for condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Efficiency condition parameters"));

  parameter Real delEffCon(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for heating capacity requirement condition"
    annotation(Dialog(tab="Staging parameters", group="Efficiency condition parameters"));

  parameter Real TDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 10
    "Required temperature difference between setpoint and measured temperature"
    annotation(Dialog(tab="Staging parameters", group="Failsafe condition parameters"));

  parameter Real delFaiCon(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 900
    "Enable delay for temperature condition"
    annotation(Dialog(tab="Staging parameters", group="Failsafe condition parameters"));

  parameter Real sigDif(
    final unit="1",
    displayUnit="1") = 0.1
    "Signal hysteresis deadband"
    annotation (Dialog(tab="Advanced", group="Efficiency condition parameters"));

  parameter Real TDifHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Temperature deadband for hysteresis loop"
    annotation(Dialog(tab="Advanced", group="Failsafe condition parameters"));

  parameter Real fraMinFir(
    final unit="1",
    displayUnit="1") = 1.1
    "Fraction of boiler minimum firing rate that required capacity needs to be
    to initiate stage-down process"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delMinFir(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Delay for staging based on minimum firing rate of current stage"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real fraDesCap(
    final unit="1",
    displayUnit="1") = 0.8
    "Fraction of design capacity of next lower stage that heating capacity needs
    to be for staging down"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delDesCapNonConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for capacity requirement condition for non-condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delDesCapConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for capacity requirement condition for condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delBypVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for bypass valve condition for primary-only plants"
    annotation (
      Evaluate=true,
      Dialog(
        enable=have_priOnl,
        tab="Staging parameters",
        group="Staging down parameters"));

  parameter Real TCirDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 3
    "Required return water temperature difference between primary and secondary
    circuits for staging down"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (have_priOnl),
        tab="Staging parameters",
        group="Staging down parameters"));

  parameter Real delTRetDif(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for measured hot water return temperature difference condition"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (have_priOnl),
        tab="Staging parameters",
        group="Staging down parameters"));

  parameter Real bypValClo(
    final unit="1",
    displayUnit="1") = 0
    "Adjustment for signal received when bypass valve is closed"
    annotation (
      Evaluate=true,
      Dialog(
        enable=have_priOnl,
        tab="Advanced",
        group="Staging down parameters"));

  parameter Real dTemp(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.1
    "Hysteresis deadband for measured temperatures"
    annotation (Dialog(tab="Advanced", group="Failsafe condition parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaProEnd
    "Signal indicating end of stage change process"
    annotation (Placement(transformation(extent={{-240,-250},{-200,-210}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRetLagPri(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if not have_priOnl
    "Measured temperature of return hot water in lag primary circuit"
    annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRetSec(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if not have_priOnl
    "Measured temperature of return hot water in secondary circuit"
    annotation (Placement(transformation(extent={{-240,-150},{-200,-110}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water supply temperature setpoint for plant"
    annotation (Placement(transformation(extent={{-240,70},{-200,110}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature in the plant"
    annotation (Placement(transformation(extent={{-240,-50},{-200,-10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water return temperature in the plant"
    annotation (Placement(transformation(extent={{-240,30},{-200,70}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    displayUnit="m3/s") "Measured hot water flow rate in the plant"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapMinLagPri(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Minimum capacity of first stage of lag primary loop"   annotation (
      Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinSetLagPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum flowrate setpoint of first stage of lag primary loop"  annotation (
     Placement(transformation(extent={{-240,110},{-200,150}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpeLagPri(final unit="1", displayUnit="1")
    "Measured pump speed of lag primary loop" annotation (Placement(
        transformation(extent={{-240,180},{-200,220}}), iconTransformation(
          extent={{-140,180},{-100,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapHigLeaPri(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Design capacity of highest stage in lead primary loop" annotation (
      Placement(transformation(extent={{-240,-200},{-200,-160}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaNexPri "Enable next primary loop"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement
    capReq(final avePer=avePer) "Capacity requirement calculator"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Up staUpNexPri(
    final nSta=2,
    final fraNonConBoi=fraNonConBoi,
    final fraConBoi=fraConBoi,
    final sigDif=sigDif,
    final delEffCon=delEffCon,
    final TDif=TDif,
    final TDifHys=TDifHys,
    final delFaiCon=delFaiCon) "Stage up to next primary loop"
    annotation (Placement(transformation(extent={{0,18},{20,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down staDowNexPri(
    final have_priOnl=false,
    final nSta=2,
    final fraMinFir=fraMinFir,
    final delMinFir=delMinFir,
    final fraDesCap=fraDesCap,
    final delDesCapNonConBoi=delDesCapNonConBoi,
    final delDesCapConBoi=delDesCapConBoi,
    final sigDif=sigDif,
    final delBypVal=delBypVal,
    final bypValClo=bypValClo,
    final TCirDif=TCirDif,
    final delTRetDif=delTRetDif,
    final dTemp=dTemp,
    final TDif=TDif,
    final delFaiCon=delFaiCon,
    final boiMinPriPumSpeSta=boiMinPriPumSpeSta)
    "Stage down from next primary loop"
    annotation (Placement(transformation(extent={{0,-46},{20,-11}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[2](k={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler})
    "Integer source for currebnt stage type and next stage type"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Latch to hold status of next primary loop"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=2)
    "Integer source for next available stage"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(integerTrue=2, integerFalse=1)
    annotation (Placement(transformation(extent={{150,-30},{170,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=true)
    "Constant true signal for boiler availability"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));

equation
  connect(capReq.TSupSet, THotWatSupSet) annotation (Line(points={{-82,117},{-100,
          117},{-100,90},{-220,90}}, color={0,0,127}));
  connect(capReq.TRet, THotWatRet) annotation (Line(points={{-82,110},{-132,110},
          {-132,50},{-220,50}}, color={0,0,127}));
  connect(capReq.VHotWat_flow, VHotWat_flow) annotation (Line(points={{-82,103},
          {-126,103},{-126,10},{-220,10}}, color={0,0,127}));
  connect(capReq.y, staUpNexPri.uCapReq) annotation (Line(points={{-58,110},{-40,
          110},{-40,49},{-2,49}}, color={0,0,127}));
  connect(capReq.y, staDowNexPri.uCapReq) annotation (Line(points={{-58,110},{-40,
          110},{-40,-27},{-2,-27}}, color={0,0,127}));
  connect(VHotWat_flow, staUpNexPri.VHotWat_flow) annotation (Line(points={{-220,10},
          {-82,10},{-82,40},{-2,40}},                  color={0,0,127}));
  connect(THotWatSupSet, staUpNexPri.THotWatSupSet) annotation (Line(points={{-220,90},
          {-16,90},{-16,28},{-2,28}},                  color={0,0,127}));
  connect(THotWatSup, staUpNexPri.THotWatSup) annotation (Line(points={{-220,-30},
          {-60,-30},{-60,25},{-2,25}},            color={0,0,127}));
  connect(uStaChaProEnd, staDowNexPri.uStaChaProEnd) annotation (Line(points={{-220,
          -230},{-26,-230},{-26,-12},{-2,-12}},          color={255,0,255}));
  connect(uStaChaProEnd, staUpNexPri.uStaChaProEnd) annotation (Line(points={{-220,
          -230},{-26,-230},{-26,19},{-2,19}},            color={255,0,255}));
  connect(conInt.y, staUpNexPri.uTyp) annotation (Line(points={{-98,-10},{-80,-10},
          {-80,34},{-2,34}},           color={255,127,0}));
  connect(conInt.y, staDowNexPri.uTyp) annotation (Line(points={{-98,-10},{-80,-10},
          {-80,-15},{-2,-15}},              color={255,127,0}));
  connect(staUpNexPri.yStaUp, lat.u) annotation (Line(points={{22,34},{40,34},{40,
          0},{68,0}},                 color={255,0,255}));
  connect(staDowNexPri.yStaDow, lat.clr) annotation (Line(points={{22,-30},{40,-30},
          {40,-6},{68,-6}},                color={255,0,255}));
  connect(conInt1.y, staUpNexPri.uAvaUp) annotation (Line(points={{-98,50},{-20,
          50},{-20,31},{-2,31}},            color={255,127,0}));
  connect(THotWatSupSet, staDowNexPri.THotWatSupSet) annotation (Line(points={{-220,90},
          {-16,90},{-16,-21},{-2,-21}},                color={0,0,127}));
  connect(THotWatSup, staDowNexPri.THotWatSup) annotation (Line(points={{-220,-30},
          {-60,-30},{-60,-24},{-2,-24}},          color={0,0,127}));
  connect(THotWatRetLagPri, staDowNexPri.TPriHotWatRet) annotation (Line(points=
         {{-220,-90},{-12,-90},{-12,-42},{-2,-42}}, color={0,0,127}));
  connect(THotWatRetSec, staDowNexPri.TSecHotWatRet) annotation (Line(points={{-220,
          -130},{-8,-130},{-8,-45},{-2,-45}},        color={0,0,127}));
  connect(lat.y, yEnaNexPri) annotation (Line(points={{92,0},{220,0}},
                             color={255,0,255}));
  connect(booToInt.y, staDowNexPri.uCur) annotation (Line(points={{172,-20},{180,
          -20},{180,-60},{-20,-60},{-20,-18},{-2,-18}},    color={255,127,0}));
  connect(pre.y, booToInt.u)
    annotation (Line(points={{142,-20},{148,-20}},
                                               color={255,0,255}));
  connect(lat.y, pre.u) annotation (Line(points={{92,0},{100,0},{100,-20},{118,-20}},
                      color={255,0,255}));
  connect(con.y, staUpNexPri.uAvaCur) annotation (Line(points={{-98,-60},{-74,-60},
          {-74,22},{-2,22}},           color={255,0,255}));
  connect(uCapMinLagPri, staUpNexPri.uCapUpMin) annotation (Line(points={{-220,160},
          {-34,160},{-34,43},{-2,43}},            color={0,0,127}));
  connect(uCapMinLagPri, staDowNexPri.uCapMin) annotation (Line(points={{-220,160},
          {-34,160},{-34,-30},{-2,-30}},          color={0,0,127}));
  connect(VMinSetLagPri_flow, staUpNexPri.VUpMinSet_flow) annotation (Line(
        points={{-220,130},{-26,130},{-26,37},{-2,37}},       color={0,0,127}));
  connect(uPumSpeLagPri, staDowNexPri.uPumSpe) annotation (Line(points={{-220,200},
          {-12,200},{-12,-39},{-2,-39}},     color={0,0,127}));
  connect(uCapHigLeaPri, staDowNexPri.uCapDowDes) annotation (Line(points={{-220,
          -180},{-52,-180},{-52,-33},{-2,-33}}, color={0,0,127}));
  connect(uCapHigLeaPri, staUpNexPri.uCapDes) annotation (Line(points={{-220,-180},
          {-52,-180},{-52,46},{-2,46}}, color={0,0,127}));
  annotation (defaultComponentName = "hybPlaEna",
        Icon(coordinateSystem(extent={{-100,-220},{100,220}}),
             graphics={
        Rectangle(
        extent={{-100,-220},{100,220}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,260},{110,220}},
          textColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-200,-240},{200,240}})),
Documentation(info="<html>
<p>
The sequence is a boiler stage status setpoint controller that outputs the 
boiler stage integer index <code>ySta</code>, boiler stage change trigger signals
<code>yChaEdg</code>, <code>yChaUpEdg</code>, <code>yChaDowEdg</code>, and a boiler
status vector for the current stage <code>yBoi</code>.
</p>
<p>
Implemented according to ASHRAE RP-1711 March 2020 Draft, section 5.3.3.10.
</p>
<p>
The controller contains the following subsequences:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement</a> to calculate
the capacity requirement.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Configurator\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Configurator</a> to allow the user 
to provide the boiler plant configuration parameters such as boiler design and minimal capacities and types. It 
calculates the design and minimal stage capacities, stage type and stage availability.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Status\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Status</a> to calculate
the next higher and lower available stages.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities</a> to calculate
design and minimal stage capacities for current and next available higher and lower stage.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Up</a> to generate
a stage up signal.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down</a> to generate
a stage down signal.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Change\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Change</a> to set the stage
based on the initial stage signal and stage up and down signals.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.BoilerIndices\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.BoilerIndices</a> to generate
the boiler index vector for a given stage.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
June 22, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end HybridPlantEnable;
