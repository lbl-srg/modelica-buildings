within Buildings.Fluid.Examples.FlowSystem;
model Simplified6 "Set allowFlowReversal=false"
  extends Simplified5(
    pmpNorth(allowFlowReversal=false),
    pmpSouth(allowFlowReversal=false),
    tabsSouth1(each allowFlowReversal=false),
    tabsSouth2(each allowFlowReversal=false),
    pipSouth1(allowFlowReversal=false),
    pipSouth2(allowFlowReversal=false),
    valSouth2(each allowFlowReversal=false),
    valSouth1(each allowFlowReversal=false),
    tabsNorth1(each allowFlowReversal=false),
    valNorth1(each allowFlowReversal=false),
    pipNorth1(allowFlowReversal=false),
    pipNorth2(allowFlowReversal=false),
    valNorth2(each allowFlowReversal=false),
    tabsNorth2(each allowFlowReversal=false),
    pumpHea(allowFlowReversal=false),
    vol(allowFlowReversal=false),
    heater(allowFlowReversal=false),
    valCoo(allowFlowReversal=false),
    valHea(allowFlowReversal=false));
  annotation (Documentation(info="<html>
<p>
The model is further simplified by setting <code>allowFlowReversal=false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2016, by Michael Wetter:<br/>
Added missing <code>each</code> keywords.
</li>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/FlowSystem/Simplified6.mos"
        "Simulate and plot"));
end Simplified6;
