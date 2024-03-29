/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content.logic.condition;

import org.apache.log4j.Logger;
import org.dspace.content.Item;
import org.dspace.content.logic.LogicalStatementException;
import org.dspace.core.Context;

/**
 * A condition that returns true if the item is withdrawn
 *
 * @author Kim Shepherd
 * @version $Revision$
 */
public class IsWithdrawnCondition extends AbstractCondition {
    private static Logger log = Logger.getLogger(IsWithdrawnCondition.class);

    @Override
    public Boolean getResult(Context context, Item item) throws LogicalStatementException {
        log.debug("Result of isWithdrawn is " + item.isWithdrawn());
        return item.isWithdrawn();
    }
} 
