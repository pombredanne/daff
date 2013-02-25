// -*- mode:java; tab-width:4; c-basic-offset:4; indent-tabs-mode:nil -*-

package coopy;

class TableDiff {
    private var align : Alignment;
    private var flags : CompareFlags;

    public function new(align: Alignment, flags: CompareFlags) {
        this.align = align;
        this.flags = flags;
    }


    public function hilite(output: Table) : Bool { 
        if (!output.isResizable()) return false;
        output.resize(0,0);
        output.clear();

        var order : Ordering = align.toOrder();
        var units : Array<Unit> = order.getList();
        var has_parent : Bool = (align.reference != null);
        var a : Table;
        var b : Table;
        var p : Table;
        if (has_parent) {
            p = align.getSource();
            a = align.reference.getTarget();
            b = align.getTarget();
        } else {
            a = align.getSource();
            b = align.getTarget();
            p = a;
        }

        var column_order : Ordering = align.meta.toOrder();
        var column_units : Array<Unit> = column_order.getList();

        var reps_needed : Int = flags.show_unchanged ? 1 : 2;

        var v : View = a.getCellView();

        var schema : Array<String> = new Array<String>();
        var have_schema : Bool = false;
        for (j in 0...column_units.length) {
            var cunit : Unit = column_units[j];
            var act : String = "";
            if (cunit.r>=0 && cunit.lp()==-1) {
                have_schema = true;
                act = "+++";
            }
            if (cunit.r<0 && cunit.lp()>=0) {
                have_schema = true;
                act = "---";
            }
            schema.push(act);
        }
        if (have_schema) {
            var at : Int = output.height;
            output.resize(column_units.length+1,at+1);
            output.setCell(0,at,v.toDatum("!"));
            for (j in 0...column_units.length) {
                output.setCell(j+1,at,v.toDatum(schema[j]));
            }
        }

        for (i in 0...units.length) {
            var unit : Unit = units[i];

            if (unit.r<0 && unit.l<0) continue;

            var act : String = "";

            var publish : Bool = flags.show_unchanged;
            for (rep in 0...reps_needed) {
                var at : Int = output.height;
                if (publish) {
                    output.resize(column_units.length+1,at+1);
                }

                var have_addition : Bool = false;

                if (unit.p<0 && unit.l<0 && unit.r>=0) {
                    act = "+++";
                }
                if ((unit.p>=0||!has_parent) && unit.l>=0 && unit.r<0) {
                    act = "---";
                }
                
                for (j in 0...column_units.length) {
                    var cunit : Unit = column_units[j];
                    var pp : Datum = null;
                    var ll : Datum = null;
                    var rr : Datum = null;
                    var dd : Datum = null;
                    var dd_to : Datum = null;
                    var have_pp : Bool = false;
                    var have_ll : Bool = false;
                    var have_rr : Bool = false;
                    if (cunit.p>=0 && unit.p>=0) {
                        pp = p.getCell(cunit.p,unit.p);
                        have_pp = true;
                    }
                    if (cunit.l>=0 && unit.l>=0) {
                        ll = a.getCell(cunit.l,unit.l);
                        have_ll = true;
                    }
                    if (cunit.r>=0 && unit.r>=0) {
                        rr = b.getCell(cunit.r,unit.r);
                        have_rr = true;
                        if ((have_pp ? cunit.p : cunit.l)<0) {
                            if (rr != null) {
                                if (v.toString(rr) != "") {
                                    have_addition = true;
                                }
                            }
                        }
                    }

                    // for now, just interested in p->r
                    if (have_pp) {
                        if (!have_rr) {
                            dd = pp;
                        } else {
                            // have_pp, have_rr
                            if (v.equals(pp,rr)) {
                                dd = pp;
                            } else {
                                // rr is different
                                dd = pp;
                                dd_to = rr;
                            }
                        }
                    } else if (have_ll) {
                        if (!have_rr) {
                            dd = ll;
                        } else {
                            if (v.equals(ll,rr)) {
                                dd = ll;
                            } else {
                                // rr is different
                                dd = ll;
                                dd_to = rr;
                            }
                        }
                    } else {
                        dd = rr;
                    }

                    var txt : String = v.toString(dd);
                    if (dd_to!=null) {
                        txt = txt + "->" + v.toString(dd_to);
                        act = "->";
                    }
                    if (act == "" && have_addition) {
                        act = "+";
                    }
                    if (publish) output.setCell(j+1,at,v.toDatum(txt));
                }

                if (publish) output.setCell(0,at,v.toDatum(act));
                if (act!="") {
                    publish = true;
                } else {
                    break;
                }
            }
        }
        return true;
    }


    public function test() : Report { 
        var report : Report = new Report();
        var order : Ordering = align.toOrder();
        var units : Array<Unit> = order.getList();
        var has_parent : Bool = (align.reference != null);
        var a : Table;
        var b : Table;
        var p : Table;
        if (has_parent) {
            p = align.getSource();
            a = align.reference.getTarget();
            b = align.getTarget();
        } else {
            a = align.getSource();
            b = align.getTarget();
            p = a;
        }
        
        for (i in 0...units.length) {
            var unit : Unit = units[i];
            if (unit.p<0 && unit.l<0 && unit.r>=0) {
                report.changes.push(new Change("inserted row r:" + unit.r));
            }
            if ((unit.p>=0||!has_parent) && unit.l>=0 && unit.r<0) {
                report.changes.push(new Change("deleted row l:" + unit.l));
            }
            if (unit.l>=0&&unit.r>=0) {
                var mod : Bool = false;
                var av : View = a.getCellView();
                for (j in 0...a.width) {
                    // ...
                }
            }
        }
        // we don't look at any values yet
        return report;
    }
}
