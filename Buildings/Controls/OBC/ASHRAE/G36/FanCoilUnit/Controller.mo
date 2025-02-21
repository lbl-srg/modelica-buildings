within Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit;
block Controller
  "Fan coil unit controller that comprises subsequences for controlling fan speed and supply air temperature"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
    "Cooling coil type"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="System and building parameters"));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Heating coil type"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="System and building parameters"));

  parameter Boolean have_winSen=false
    "True if the zone has window status sensor"
    annotation(__cdl(ValueInReference=false));

  parameter Boolean have_occSen=false
    "True if the zone has occupancy sensor"
    annotation(__cdl(ValueInReference=false));

  parameter Real heaDea(
    unit="1",
    displayUnit="1")=0.05
    "Heating loop signal limit above which controller operation changes from deadband mode to heating mode"
    annotation (__cdl(ValueInReference=false),
      Dialog(enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real cooDea(
    unit="1",
    displayUnit="1")=0.05
    "Cooling loop signal limit above which controller operation changes from deadband mode to cooling mode"
    annotation(__cdl(ValueInReference=false),
      Dialog(enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=
     Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of cooling loop signal controller"
    annotation (Dialog(tab="PID parameters", group="Cooling loop control",
      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Real kCoo(unit="1/K")=0.1
    "Gain for cooling control loop signal"
    annotation(Dialog(tab="PID parameters", group="Cooling loop control",
      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Real TiCoo(unit="s")=900
    "Time constant of integrator block for cooling control loop signal"
    annotation(Dialog(tab="PID parameters", group="Cooling loop control",
      enable=(controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
              or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
          and (cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
               or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil)));

  parameter Real TdCoo(unit="s")=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(tab="PID parameters", group="Cooling loop control",
      enable=(controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
          and (cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
               or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil)));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of heating loop signal controller"
    annotation(Dialog(tab="PID parameters", group="Heating loop control",
      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real kHea(unit="1/K")=0.1
    "Gain for heating control loop signal"
    annotation(Dialog(tab="PID parameters", group="Heating loop control",
      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real TiHea(unit="s")=900
    "Time constant of integrator block for heating control loop signal"
    annotation(Dialog(tab="PID parameters", group="Heating loop control",
      enable=(controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
             or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
        and (heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric)));

  parameter Real TdHea(unit="s")=0.1
    "Time constant of derivative block for heating control loop signal"
    annotation (Dialog(tab="PID parameters", group="Heating loop control",
      enable=(controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
          and (heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
              or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric)));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of cooling coil controller"
    annotation(Dialog(tab="PID parameters", group="Cooling coil control",
      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Real kCooCoi(unit="1/K")=0.1
    "Gain for cooling coil control signal"
    annotation(Dialog(tab="PID parameters", group="Cooling coil control",
      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Real TiCooCoi(unit="s")=900
    "Time constant of integrator block for cooling coil control signal"
    annotation(Dialog(tab="PID parameters", group="Cooling coil control",
      enable=(controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
             or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
        and (cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil)));

  parameter Real TdCooCoi(unit="s")=0.1
    "Time constant of derivative block for cooling coil control signal"
    annotation (Dialog(tab="PID parameters", group="Cooling coil control",
      enable=(controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
          and (cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
              or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil)));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHeaCoi=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of heating coil controller"
    annotation(Dialog(tab="PID parameters", group="Heating coil control",
      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real kHeaCoi(unit="1/K")=0.1
    "Gain for heating coil control signal"
    annotation(Dialog(tab="PID parameters", group="Heating coil control",
      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real TiHeaCoi(unit="s")=900
    "Time constant of integrator block for heating coil control signal"
    annotation(Dialog(tab="PID parameters", group="Heating coil control",
    enable=(controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
            or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
        and (heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric)));

  parameter Real TdHeaCoi(unit="s")=0.1
    "Time constant of derivative block for heatinging coil control signal"
    annotation (Dialog(tab="PID parameters", group="Heating coil control",
      enable=(controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
          and (heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
              or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric)));

  parameter Real uCooFan_min(unit="1")=0.5
    "Cooling loop signal limit at which supply air temperature is at minimum and fan speed starts to be modified"
    annotation (Dialog(tab="Supply air setpoints",
      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Real uHeaFan_min(unit="1")=0.5
    "Heating loop signal limit at which supply air temperature is at maximum and fan speed starts to be modified"
    annotation (Dialog(tab="Supply air setpoints",
      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real TSupSet_max(unit="K", displayUnit="degC")
    "Maximum supply air temperature for heating"
    annotation (Dialog(tab="Supply air setpoints",group="Temperature limits",
      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real TSupSet_min(unit="K", displayUnit="degC")
    "Minimum supply air temperature for cooling"
    annotation (Dialog(tab="Supply air setpoints",group="Temperature limits",
      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Real deaSpe(
    unit="1",
    displayUnit="1")=0.1
    "Deadband mode fan speed"
    annotation (__cdl(ValueInReference=false),
      Dialog(tab="Supply air setpoints",group="Fan speed"));

  parameter Real uHeaFan_max(unit="1")=1
    "Maximum heating loop signal at which fan speed is modified"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Heating",
      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real heaSpe_max(unit="1")=1
    "Maximum fan speed for heating"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Heating",
      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real heaSpe_min(unit="1")=0.1
    "Minimum fan speed for heating"
    annotation (__cdl(ValueInReference=false),
      Dialog(tab="Supply air setpoints",group="Fan speed - Heating",
      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
             or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric));

  parameter Real uCooFan_max(unit="1")=1
    "Maximum cooling loop signal at which fan speed is modified"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Cooling",
      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Real cooSpe_max(unit="1")=1
    "Maximum fan speed for cooling"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Cooling",
      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Real cooSpe_min(unit="1")=0.1
    "Minimum fan speed for cooling"
    annotation (__cdl(ValueInReference=false),
      Dialog(tab="Supply air setpoints",group="Fan speed - Cooling",
      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
             or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil));

  parameter Boolean have_locAdj=true
    "Flag, set to true if both cooling and heating setpoint are adjustable through a single common knob"
    annotation (Dialog(tab="Adjust temperature setpoint", group="General"));

  parameter Boolean sepAdj=false
    "True: cooling and heating setpoint can be adjusted separately"
    annotation (Dialog(tab="Adjust temperature setpoint", group="General"));

  parameter Boolean ignDemLim=false
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (Dialog(tab="Adjust temperature setpoint", group="General"));

  parameter Real bouLim=1
    "Threshold of temperature difference for indicating the end of setback or setup mode"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Advanced"));

  parameter Real TActCoo_max(
    unit="K",
    displayUnit="degC")=300.15
    "Maximum cooling setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TActCoo_min(
    unit="K",
    displayUnit="degC")=295.15
    "Minimum cooling setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TActHea_max(
    unit="K",
    displayUnit="degC")=295.15
    "Maximum heating setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TActHea_min(
    unit="K",
    displayUnit="degC")=291.15
    "Minimum heating setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TWinOpeCooSet(
    unit="K",
    displayUnit="degC")=322.15
    "Cooling setpoint when window is open"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TWinOpeHeaSet(
    unit="K",
    displayUnit="degC")=277.15
    "Heating setpoint when window is open"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real incTSetDem_1(
    unit="K",
    displayUnit="K")=0.56
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real incTSetDem_2(
    unit="K",
    displayUnit="K")=1.1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real incTSetDem_3(
    unit="K",
    displayUnit="K")=2.2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real decTSetDem_1(
    unit="K",
    displayUnit="K")=0.56
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real decTSetDem_2(
    unit="K",
    displayUnit="K")=1.1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real decTSetDem_3(
    unit="K",
    displayUnit="K")=2.2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real chiWatPlaReqLim0(
    unit="1",
    displayUnit="1")=0.1
    "Valve position limit below which zero chilled water plant requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Chilled water plant requests",
                      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased));

  parameter Real chiWatResReqLim0(
    unit="1",
    displayUnit="1")=0.85
    "Valve position limit below which zero chilled water reset requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Chilled water temperature reset requests",
                      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased));

  parameter Real chiWatPlaReqLim1(
    unit="1",
    displayUnit="1")=0.95
    "Valve position limit above which one chilled water plant request is sent"
    annotation(Dialog(tab="Request limits", group="Chilled water plant requests",
                      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased));

  parameter Real chiWatResReqLim2(
    unit="K",
    displayUnit="K")=2.78
    "Temperature difference limit between setpoint and supply air temperature above which two chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water temperature reset requests",
                      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased));

  parameter Real chiWatResReqTimLim2(
    unit="s",
    displayUnit="s")=300
    "Time period for which chiWatResReqLim2 has to be exceeded before two chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water temperature reset requests",
                      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased));

  parameter Real chiWatResReqLim3(
    unit="K",
    displayUnit="K")=5.56
    "Temperature difference limit between setpoint and supply air temperature above which three chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water temperature reset requests",
                      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased));

  parameter Real chiWatResReqTimLim3(
    unit="s",
    displayUnit="s")=300
    "Time period for which chiWatResReqLim3 has to be exceeded before three chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water temperature reset requests",
                      enable=cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased));

  parameter Real hotWatPlaReqLim0(
    unit="1",
    displayUnit="1")=0.1
    "Valve position limit below which zero hot water plant requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests",
                      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));

  parameter Real hotWatResReqLim0(
    unit="1",
    displayUnit="1")=0.85
    "Valve position limit below which zero hot water reset requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests",
                      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));

  parameter Real hotWatPlaReqLim1(
    unit="1",
    displayUnit="1")=0.95
    "Valve position limit above which one hot water plant request is sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests",
                      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));

  parameter Real hotWatResReqLim2(
    unit="K",
    displayUnit="K")=8
    "Temperature difference limit between setpoint and supply air temperature above which two hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests",
                      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));

  parameter Real hotWatResReqTimLim2(
    unit="s",
    displayUnit="s")=300
    "Time period for which hotWatResReqLim2 has to be exceeded before two hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests",
                      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));

  parameter Real hotWatResReqLim3(
    unit="K",
    displayUnit="K")=17
    "Temperature difference limit between setpoint and supply air temperature above which three hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests",
                      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));

  parameter Real hotWatResReqTimLim3(
    unit="s",
    displayUnit="s")=300
    "Time period for which hotWatResReqLim3 has to be exceeded before three hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests",
                      enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));

  parameter Real uLow(
    unit="1",
    displayUnit="1")=-0.1
    "Lower limit of the hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  parameter Real uHigh(
    unit="1",
    displayUnit="1")=0.1
    "Higher limit of the hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  parameter Real deaHysLim(
    unit="1",
    displayUnit="1")=0.01
    "Hysteresis limits for cooling and heating loop signals for deadband mode transitions"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  parameter Real preWarCooTim(
    unit="s",
    displayUnit="s")=10800
    "Maximum cool-down or warm-up time"
    annotation(Dialog(tab="Advanced", group="Operation mode"));

  parameter Real Thys(
    unit="1",
    displayUnit="1")=0.1
    "Hysteresis for checking temperature difference"
    annotation(__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  parameter Real dFanSpe(
    unit="1",
    displayUnit="1")=0.05
    "Fan speed hysteresis difference"
    annotation(__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
      iconTransformation(extent={{-240,82},{-200,122}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
    annotation (Placement(transformation(extent={{-260,-280},{-220,-240}}),
      iconTransformation(extent={{-240,-360},{-200,-320}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-260,-250},{-220,-210}}),
      iconTransformation(extent={{-240,-320},{-200,-280}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-260,30},{-220,70}}),
      iconTransformation(extent={{-240,40},{-200,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-260,0},{-220,40}}),
      iconTransformation(extent={{-240,0},{-200,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nOcc if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-260,-220},{-220,-180}}),
      iconTransformation(extent={{-240,-280},{-200,-240}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    displayUnit="min",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-260,240},{-220,280}}),
      iconTransformation(extent={{-240,340},{-200,380}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    displayUnit="min",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-260,270},{-220,310}}),
      iconTransformation(extent={{-240,300},{-200,340}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    displayUnit="min",
    final quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-260,210},{-220,250}}),
      iconTransformation(extent={{-240,260},{-200,300}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-240,-80},{-200,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-260,-30},{-220,10}}),
      iconTransformation(extent={{-240,-40},{-200,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj(
    final unit="K",
    displayUnit="degC",
    final quantity="TemperatureDifference")
    if have_locAdj and not sepAdj
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-260,150},{-220,190}}),
      iconTransformation(extent={{-240,200},{-200,240}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooSetAdj(
    final unit="K",
    displayUnit="degC",
    final quantity="TemperatureDifference") if have_locAdj and sepAdj
    "Cooling setpoint adjustment value"
    annotation (Placement(transformation(extent={{-260,120},{-220,160}}),
      iconTransformation(extent={{-240,160},{-200,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj(
    final unit="K",
    displayUnit="degC",
    final quantity="TemperatureDifference") if have_locAdj and sepAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-260,90},{-220,130}}),
      iconTransformation(extent={{-240,122},{-200,162}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Occupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-260,-90},{-220,-50}}),
      iconTransformation(extent={{-240,-120},{-200,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Occupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-260,-120},{-220,-80}}),
      iconTransformation(extent={{-240,-160},{-200,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-260,-150},{-220,-110}}),
      iconTransformation(extent={{-240,-200},{-200,-160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-260,-180},{-220,-140}}),
      iconTransformation(extent={{-240,-240},{-200,-200}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Fan command on status"
    annotation (Placement(transformation(extent={{200,220},{240,260}}),
      iconTransformation(extent={{200,180},{240,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatResReq
    if cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{200,-80},{240,-40}}),
      iconTransformation(extent={{200,-100},{240,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiPlaReq
    if cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
    "Chiller plant requests"
    annotation (Placement(transformation(extent={{200,-120},{240,-80}}),
      iconTransformation(extent={{200,-140},{240,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatResReq
     if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{200,-160},{240,-120}}),
      iconTransformation(extent={{200,-180},{240,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Hot water plant requests"
    annotation (Placement(transformation(extent={{200,-200},{240,-160}}),
      iconTransformation(extent={{200,-220},{240,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{200,20},{240,60}}),
      iconTransformation(extent={{200,-60},{240,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final min=0,
    final max=1,
    final unit="1")
    "Fan command speed"
    annotation (Placement(transformation(extent={{200,180},{240,220}}),
      iconTransformation(extent={{200,140},{240,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{200,140},{240,180}}),
      iconTransformation(extent={{200,100},{240,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
      iconTransformation(extent={{200,60},{240,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    if cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
       or cooCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil
    "Cooling coil control signal"
    annotation (Placement(transformation(extent={{200,-40},{240,0}}),
      iconTransformation(extent={{200,-20},{240,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased or heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric
    "Heating coil control signal"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{200,20},{240,60}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints modSetPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final sepAdj=sepAdj,
    final TActCoo_max=TActCoo_max,
    final TActCoo_min=TActCoo_min,
    final TActHea_max=TActHea_max,
    final TActHea_min=TActHea_min,
    final TWinOpeCooSet=TWinOpeCooSet,
    final TWinOpeHeaSet=TWinOpeHeaSet,
    final have_locAdj=have_locAdj,
    final ignDemLim=ignDemLim,
    final incTSetDem_1=incTSetDem_1,
    final incTSetDem_2=incTSetDem_2,
    final incTSetDem_3=incTSetDem_3,
    final decTSetDem_1=decTSetDem_1,
    final decTSetDem_2=decTSetDem_2,
    final decTSetDem_3=decTSetDem_3,
    final bouLim=bouLim,
    final uLow=uLow,
    final uHigh=uHigh,
    final preWarCooTim=preWarCooTim)
    "Zone setpoint and operation mode"
    annotation (Placement(transformation(extent={{-140,190},{-120,230}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset cooPI(
    final reverseActing=false,
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo) if cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
     or cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil
    "Zone cooling control signal"
    annotation (Placement(transformation(extent={{-40,196},{-20,216}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset heaPI(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea) if heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
     or heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric
    "Zone heating control signal"
    annotation (Placement(transformation(extent={{-80,250},{-60,270}})));


protected
  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.PlantRequests fcuPlaReq(
    final have_hotWatCoi=heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final have_chiWatCoi=cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    final cooSpe_max=cooSpe_max,
    final heaSpe_max=heaSpe_max,
    final chiWatPlaReqLim0=chiWatPlaReqLim0,
    final chiWatResReqLim0=chiWatResReqLim0,
    final chiWatPlaReqLim1=chiWatPlaReqLim1,
    final chiWatResReqLim2=chiWatResReqLim2,
    final chiWatResReqTimLim2=chiWatResReqTimLim2,
    final chiWatResReqLim3=chiWatResReqLim3,
    final chiWatResReqTimLim3=chiWatResReqTimLim3,
    final hotWatPlaReqLim0=hotWatPlaReqLim0,
    final hotWatResReqLim0=hotWatResReqLim0,
    final hotWatPlaReqLim1=hotWatPlaReqLim1,
    final hotWatResReqLim2=hotWatResReqLim2,
    final hotWatResReqTimLim2=hotWatResReqTimLim2,
    final hotWatResReqLim3=hotWatResReqLim3,
    final hotWatResReqTimLim3=hotWatResReqTimLim3,
    final Thys=Thys,
    final dFanSpe=dFanSpe) if cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
     or heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Block for generating chilled water requests and hot water requests for their respective plants"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOccMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-160,-290},{-140,-270}})));

  Buildings.Controls.OBC.CDL.Integers.Equal isUnOcc
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-100,-290},{-80,-270}})));

  Buildings.Controls.OBC.CDL.Logical.Not isOcc
    "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{-70,-290},{-50,-270}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(
    final k=false) if not have_winSen
    "Window status"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold havOcc(
    final t=1) if have_occSen
    "Check if there is occupant"
    annotation (Placement(transformation(extent={{-202,-220},{-182,-200}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.SupplyAirTemperature TSupAir(
    final have_cooCoi=cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
         or cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil,
    final have_heaCoi=heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
         or heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric,
    final TSupSet_max=TSupSet_max,
    final uHea_max=uHeaFan_min,
    final TSupSet_min=TSupSet_min,
    final uCoo_max=uCooFan_min,
    final heaDea=heaDea,
    final cooDea=cooDea,
    final controllerTypeCooCoi=controllerTypeCooCoi,
    final kCooCoi=kCooCoi,
    final TiCooCoi=TiCooCoi,
    final TdCooCoi=TdCooCoi,
    final controllerTypeHeaCoi=controllerTypeHeaCoi,
    final kHeaCoi=kHeaCoi,
    final TiHeaCoi=TiHeaCoi,
    final TdHeaCoi=TdHeaCoi,
    final deaHysLim=deaHysLim) "Supply air temperature setpoint controller"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.FanSpeed fanSpe(
    final have_cooCoi=cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
         or cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil,
    final have_heaCoi=heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
         or heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric,
    final deaSpe=deaSpe,
    final heaSpe_min=heaSpe_min,
    final uHea_min=uHeaFan_min,
    final heaSpe_max=heaSpe_max,
    final uHea_max=uHeaFan_max,
    final cooSpe_min=cooSpe_min,
    final uCoo_min=uCooFan_min,
    final cooSpe_max=cooSpe_max,
    final uCoo_max=uCooFan_max,
    final heaDea=heaDea,
    final cooDea=cooDea,
    final deaHysLim=deaHysLim) "Fan speed controller"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));

equation
  connect(unOccMod.y, isUnOcc.u2) annotation (Line(points={{-138,-280},{-120,-280},
          {-120,-288},{-102,-288}}, color={255,127,0}));
  connect(isUnOcc.y, isOcc.u)
    annotation (Line(points={{-78,-280},{-72,-280}}, color={255,0,255}));
  connect(TZon, cooPI.u_m) annotation (Line(points={{-240,-40},{-30,-40},{-30,194}},
          color={0,0,127}));
  connect(isOcc.y, heaPI.trigger) annotation (Line(points={{-48,-280},{-36,-280},
          {-36,124},{-76,124},{-76,248}}, color={255,0,255}));
  connect(isOcc.y, cooPI.trigger) annotation (Line(points={{-48,-280},{-36,-280},
          {-36,194}}, color={255,0,255}));
  connect(TZon, heaPI.u_m) annotation (Line(points={{-240,-40},{-70,-40},{-70,248}},
          color={0,0,127}));
  connect(modSetPoi.THeaSet, heaPI.u_s) annotation (Line(points={{-118,202},{-100,
          202},{-100,260},{-82,260}},      color={0,0,127}));
  connect(modSetPoi.THeaSet, TZonHeaSet) annotation (Line(points={{-118,202},{-54,
          202},{-54,160},{220,160}},        color={0,0,127}));
  connect(modSetPoi.TCooSet, cooPI.u_s) annotation (Line(points={{-118,210},{-50,
          210},{-50,206},{-42,206}}, color={0,0,127}));
  connect(modSetPoi.TCooSet, TZonCooSet) annotation (Line(points={{-118,210},{-50,
          210},{-50,120},{220,120}},    color={0,0,127}));
  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-240,-40},{-208,-40},{
          -208,220},{-142,220}}, color={0,0,127}));
  connect(tNexOcc, modSetPoi.tNexOcc) annotation (Line(points={{-240,230},{-180,
          230},{-180,206},{-142,206}}, color={0,0,127}));
  connect(u1Occ, modSetPoi.u1Occ) annotation (Line(points={{-240,80},{-184,80},{
          -184,208},{-142,208}}, color={255,0,255}));
  connect(modSetPoi.yOpeMod, isUnOcc.u1) annotation (Line(points={{-118,218},{-110,
          218},{-110,-280},{-102,-280}}, color={255,127,0}));
  connect(win.y, modSetPoi.u1Win) annotation (Line(points={{-178,-180},{-150,-180},
          {-150,223},{-142,223}}, color={255,0,255}));
  connect(u1Win, modSetPoi.u1Win) annotation (Line(points={{-240,-260},{-150,-260},
          {-150,223},{-142,223}}, color={255,0,255}));
  connect(havOcc.y, modSetPoi.u1OccSen) annotation (Line(points={{-180,-210},{
          -164,-210},{-164,196},{-142,196}},                color={255,0,255}));
  connect(modSetPoi.warUpTim, warUpTim) annotation (Line(points={{-142,226},{-166,
          226},{-166,260},{-240,260}}, color={0,0,127}));
  connect(modSetPoi.cooDowTim, cooDowTim) annotation (Line(points={{-142,228},{-160,
          228},{-160,290},{-240,290}}, color={0,0,127}));
  connect(modSetPoi.uCooDemLimLev, uCooDemLimLev) annotation (Line(points={{-142,
          194},{-160,194},{-160,50},{-240,50}}, color={255,127,0}));
  connect(modSetPoi.uHeaDemLimLev, uHeaDemLimLev) annotation (Line(points={{-142,
          192},{-156,192},{-156,20},{-240,20}}, color={255,127,0}));
  connect(TSupAir.yCooCoi, yCooCoi) annotation (Line(points={{62,44},{90,44},{90,
          -20},{220,-20}}, color={0,0,127}));
  connect(TSupAir.yHeaCoi, yHeaCoi) annotation (Line(points={{62,56},{80,56},{80,
          80},{220,80}}, color={0,0,127}));
  connect(TSupAir.TSupSet, TSupSet) annotation (Line(points={{62,50},{100,50},{100,
          40},{220,40}}, color={0,0,127}));
  connect(fanSpe.yFan, yFan) annotation (Line(points={{62,218},{160,218},{160,200},
          {220,200}}, color={0,0,127}));
  connect(fanSpe.y1Fan, y1Fan) annotation (Line(points={{62,222},{160,222},{160,
          240},{220,240}}, color={255,0,255}));
  connect(modSetPoi.yOpeMod, fanSpe.opeMod) annotation (Line(points={{-118,218},
          {-60,218},{-60,226},{38,226}},  color={255,127,0}));
  connect(TSup, TSupAir.TAirSup) annotation (Line(points={{-240,-10},{-80,-10},{
          -80,48},{38,48}},color={0,0,127}));
  connect(u1Fan, fanSpe.u1FanPro) annotation (Line(points={{-240,-230},{8,-230},
          {8,222},{38,222}},  color={255,0,255}));
  connect(heaPI.y, fanSpe.uHea) annotation (Line(points={{-58,260},{0,260},{0,218},
          {38,218}},  color={0,0,127}));
  connect(cooPI.y, fanSpe.uCoo) annotation (Line(points={{-18,206},{20,206},{20,
          214},{38,214}},  color={0,0,127}));
  connect(modSetPoi.TCooSet,TSupAir.TZonCooSet)  annotation (Line(points={{-118,
          210},{-50,210},{-50,41},{38,41}},    color={0,0,127}));
  connect(modSetPoi.THeaSet,TSupAir.TZonHeaSet)  annotation (Line(points={{-118,
          202},{-54,202},{-54,55},{38,55}},    color={0,0,127}));
  connect(cooPI.y, TSupAir.uCoo) annotation (Line(points={{-18,206},{20,206},{20,
          45},{38,45}},    color={0,0,127}));
  connect(heaPI.y, TSupAir.uHea) annotation (Line(points={{-58,260},{0,260},{0,52},
          {38,52}},   color={0,0,127}));
  connect(u1Fan, TSupAir.u1Fan) annotation (Line(points={{-240,-230},{8,-230},{8,
          59},{38,59}}, color={255,0,255}));
  connect(nOcc, havOcc.u) annotation (Line(points={{-240,-200},{-212,-200},{
          -212,-210},{-204,-210}},
                            color={255,127,0}));
  connect(cooSetAdj, modSetPoi.cooSetAdj) annotation (Line(points={{-240,140},{-172,
          140},{-172,201},{-142,201}}, color={0,0,127}));
  connect(heaSetAdj, modSetPoi.heaSetAdj) annotation (Line(points={{-240,110},{-168,
          110},{-168,199},{-142,199}}, color={0,0,127}));
  connect(TSup, fcuPlaReq.TAirSup) annotation (Line(points={{-240,-10},{-80,-10},
          {-80,-46},{118,-46}}, color={0,0,127}));
  connect(fcuPlaReq.yChiWatResReq, yChiWatResReq) annotation (Line(points={{142,-44},
          {180,-44},{180,-60},{220,-60}},  color={255,127,0}));
  connect(fcuPlaReq.yChiPlaReq, yChiPlaReq) annotation (Line(points={{142,-48},{
          176,-48},{176,-100},{220,-100}}, color={255,127,0}));
  connect(fcuPlaReq.yHotWatResReq, yHotWatResReq) annotation (Line(points={{142,-52},
          {170,-52},{170,-140},{220,-140}}, color={255,127,0}));
  connect(fcuPlaReq.yHotWatPlaReq, yHotWatPlaReq) annotation (Line(points={{142,-56},
          {164,-56},{164,-180},{220,-180}}, color={255,127,0}));
  connect(TSupAir.TSupSet, fcuPlaReq.TAirSupSet) annotation (Line(points={{62,50},
          {100,50},{100,-50},{118,-50}}, color={0,0,127}));
  connect(fanSpe.yFan, fcuPlaReq.uFan) annotation (Line(points={{62,218},{110,218},
          {110,-42},{118,-42}},  color={0,0,127}));
  connect(TOccHeaSet, modSetPoi.TOccHeaSet) annotation (Line(points={{-240,-70},
          {-202,-70},{-202,217},{-142,217}}, color={0,0,127}));
  connect(TOccCooSet, modSetPoi.TOccCooSet) annotation (Line(points={{-240,-100},
          {-196,-100},{-196,215},{-142,215}}, color={0,0,127}));
  connect(TUnoHeaSet, modSetPoi.TUnoHeaSet) annotation (Line(points={{-240,-130},
          {-192,-130},{-192,213},{-142,213}}, color={0,0,127}));
  connect(TUnoCooSet, modSetPoi.TUnoCooSet) annotation (Line(points={{-240,-160},
          {-188,-160},{-188,211},{-142,211}}, color={0,0,127}));
  connect(TSupAir.yHeaCoi, fcuPlaReq.uHeaCoiSet) annotation (Line(points={{62,56},
          {80,56},{80,-58},{118,-58}}, color={0,0,127}));
  connect(TSupAir.yCooCoi, fcuPlaReq.uCooCoiSet) annotation (Line(points={{62,44},
          {90,44},{90,-53.8},{118,-53.8}}, color={0,0,127}));
  connect(setAdj, modSetPoi.setAdj) annotation (Line(points={{-240,170},{-176,170},
          {-176,203},{-142,203}}, color={0,0,127}));
annotation (defaultComponentName="conFCU",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-400},{200,400}}),
        graphics={Rectangle(
          extent={{-200,-400},{200,400}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-200,500},{200,400}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-196,296},{-134,268}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="tNexOcc"),
        Text(
          extent={{-200,-48},{-156,-68}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          extent={{-196,114},{-150,94}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1Occ"),
        Text(
          extent={{-200,-8},{-152,-30}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Text(
          extent={{-198,-272},{-152,-244}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="nOcc",
          visible=have_occSen),
        Text(
          visible=have_winSen,
          extent={{-196,-326},{-152,-348}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1Win"),
        Text(
          extent={{132,-22},{198,-56}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupSet"),
        Text(
          extent={{148,172},{200,136}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yFan"),
        Text(
          extent={{116,136},{194,102}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet"),
        Text(
          extent={{116,98},{196,60}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet"),
        Text(
          extent={{142,60},{196,22}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi",
          visible=heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
               or heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric),
        Text(
          extent={{142,20},{196,-18}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi",
          visible=cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased
               or cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.DXCoil),
        Text(
          extent={{-194,378},{-120,346}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="warUpTim"),
        Text(
          extent={{-194,338},{-114,306}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooDowTim"),
        Text(
          extent={{-194,74},{-82,52}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooDemLimLev"),
        Text(
          extent={{-194,32},{-82,10}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaDemLimLev"),
        Text(
          extent={{-196,-290},{-150,-310}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1Fan"),
        Text(
          extent={{144,212},{188,190}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1Fan"),
        Text(
          extent={{-198,236},{-136,208}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="setAdj",
          visible=have_locAdj and not sepAdj),
        Text(
          extent={{106,-90},{198,-66}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yChiWatResReq",
          visible=cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased),
        Text(
          extent={{132,-130},{198,-108}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yChiPlaReq",
          visible=cooCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased),
        Text(
          extent={{104,-170},{196,-146}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHotWatResReq",
          visible=heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased),
        Text(
          extent={{106,-210},{198,-186}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHotWatPlaReq",
          visible=heaCoi == Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased),
        Text(
          extent={{-196,-86},{-104,-114}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOccHeaSet"),
        Text(
          extent={{-194,-128},{-98,-152}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOccCooSet"),
        Text(
          extent={{-194,-168},{-98,-190}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TUnoHeaSet"),
        Text(
          extent={{-200,-208},{-94,-230}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TUnoCooSet"),
        Text(
          extent={{-196,196},{-124,168}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooSetAdj",
          visible=have_locAdj and sepAdj),
        Text(
          extent={{-196,156},{-124,128}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="heaSetAdj",
          visible=have_locAdj and sepAdj)}),
          Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-220,-300},{200,300}})),
Documentation(info="<html>
<p>
Block for fan coil unit control. It outputs supply fan enable signal and speed signal,
the supply air temperature setpoint, the zone air heating and cooling setpoints,
and commanded valve positions for heating and cooling coils.
</p>
<p>
It is implemented according to the ASHRAE Guideline 36-2021, Part 5.22.
</p>
<p>
The sequences consist of the following subsequences.
</p>
<h4>Supply fan control</h4>
<p>
The supply fan control is implemented according to Part 5.22.4. It outputs
the control signals for supply fan enable <code>yFan</code> and the fan speed
<code>yFanSpe</code>.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.FanSpeed\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.FanSpeed</a> for more detailed
description.
</p>
<h4>Supply air temperature setpoint</h4>
<p>
The supply air temperature setpoint control sequences are implemented based on Part 5.22.4.
The block outputs a supply air temperature setpoint signal <code>TSupSet</code>,
and control signals for the heating coil <code>yHeaCoi</code> and the cooling coil
<code>yCooCoi</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.SupplyAirTemperature\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.SupplyAirTemperature</a>
for more detailed description.
</p>
<h4>Zone air heating and cooling setpoints</h4>
<p>
The zone air heating setpoint <code>TZonHeaSet</code>and cooling setpoint <code>TZonHeaSet</code>
as well as system operation mode signal <code>modSetPoi.yOpeMod</code> are described at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints</a>.
</p>
<h4>Plant requests</h4>
<p>
The plant requests are implemented based on Part 5.22.8.
The block outputs a chilled water plant request <code>yChiPlaReq</code>, chilled
water supply temperature reset request <code>yChiWatResReq</code>, hot water plant
request <code>yHotWatPlaReq</code> and hot water supply temperature reset request
<code>yHotWatResReq</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.PlantRequests\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnit.Subsequences.PlantRequests</a>
for more detailed description.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 22, 2022, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
