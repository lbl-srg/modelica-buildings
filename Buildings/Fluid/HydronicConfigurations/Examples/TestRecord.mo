within Buildings.Fluid.HydronicConfigurations.Examples;
model TestRecord
  extends Modelica.Icons.Example;

  record Config
    parameter Boolean have_characteristic
      annotation(Evaluate=true);
  end Config;

  record Data
    parameter Config cfg
      annotation(Evaluate=true);
    parameter Real par(start=0)
      annotation(Dialog(enable=cfg.have_characteristic));
  end Data;

  model Component
    parameter Data dat(cfg(final have_characteristic=have_characteristic));
    parameter Boolean have_characteristic = true;
  end Component;

  Component com(final have_characteristic=false, final dat=dat)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  parameter Data dat(
    cfg=Config(com))
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

end TestRecord;
