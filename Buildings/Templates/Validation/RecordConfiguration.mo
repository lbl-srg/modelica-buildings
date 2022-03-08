within Buildings.Templates.Validation;
model RecordConfiguration
  extends Modelica.Icons.Example;

  record Data
    parameter DataConfiguration cfg;
    parameter DataSchedule sch(final typ=cfg.typ);
  end Data;

  record DataConfiguration
    parameter Integer typ;
  end DataConfiguration;

  record DataSchedule
    parameter Integer typ;
    parameter Real m_flow_nominal;
  end DataSchedule;

  model Model
     parameter Data dat(cfg(final typ=1));
  end Model;

  Model mod(dat(final sch=dat.mod.sch));

  record DataTopLevel
    Data mod;
  end DataTopLevel;

  DataTopLevel dat(
    mod(
      final cfg=mod.dat.cfg,
      sch(m_flow_nominal=1)));

end RecordConfiguration;
