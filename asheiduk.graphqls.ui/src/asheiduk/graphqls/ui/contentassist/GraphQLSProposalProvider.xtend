package asheiduk.graphqls.ui.contentassist

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor

/**
 * See https://www.eclipse.org/Xtext/documentation/304_ide_concepts.html#content-assist
 * on how to customize the content assistant.
 */
class GraphQLSProposalProvider extends AbstractGraphQLSProposalProvider {
	
	// -- Terminals
	
	override complete_INT(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		acceptProposal("42", context, acceptor)
	}
	
	override complete_FLOAT(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		acceptProposal("42.42e42", context, acceptor)
	}
	
	override complete_STRING(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		acceptProposal('""', context, acceptor)
	}
	
	override complete_ID(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		acceptProposal("Name", context, acceptor)
	}

// It seems, hidden token are not suggested at all.	
//	override complete_SL_COMMENT(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
//		acceptProposal("# ", context, acceptor)
//	}
	
	override complete_Description(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		acceptProposal('"""description"""', context, acceptor)
	}
	
	// -- Tools
	
	def private acceptProposal(String value, ContentAssistContext context, ICompletionProposalAcceptor acceptor){
		acceptor.accept(createCompletionProposal(value, context))
	}
}
