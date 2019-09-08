package asheiduk.graphqls.tests

import asheiduk.graphqls.services.GraphQLSGrammarAccess
import java.util.HashSet
import java.util.Set
import java.util.regex.Pattern
import javax.inject.Inject
import org.eclipse.xtext.AbstractRule
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.TerminalRule
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

import static org.junit.Assert.assertEquals

@ExtendWith(InjectionExtension)
@InjectWith(GraphQLSInjectorProvider)
class GrammarTest {
	
	static val ID_PATTERN = Pattern.compile('[_a-zA-Z][_a-zA-Z0-9]*')
	
	@Inject extension GraphQLSGrammarAccess
	
	@Test
	def void keywordsAsNames(){
		val knownMissing = #{
			'on'
		}
		
		val excludedRules = #{IDRule, predefinedScalarRule}
		val allOtherKeywords = grammar.rules.reject[excludedRules.contains(it)].findNonTerminalKeywords
		val idRuleKeywords = IDRule.findNonTerminalKeywords
		
		val missingKeywords = new HashSet(allOtherKeywords) => [
			removeAll(knownMissing)
			removeAll(idRuleKeywords)
		]
		assertEquals('''keywords not in 'ID' rule:«'\n'»«missingKeywords.showKeywords»''', 0, missingKeywords.size)
		
		val additionalKeywords = new HashSet(idRuleKeywords) => [
			removeAll(allOtherKeywords)
		]
		assertEquals('''additional keywords in 'ID' rule:«'\n'»«additionalKeywords.showKeywords»''', 0, additionalKeywords.size)
		
		val supposedMissingButFound = new HashSet(knownMissing) => [
			retainAll(idRuleKeywords)
		]
		assertEquals('''previsously missing keywords found in 'ID' rule:«'\n'»«supposedMissingButFound.showKeywords»''', 0, supposedMissingButFound.size)
	}
	
	def findNonTerminalKeywords(AbstractRule rule){
		#[rule].findNonTerminalKeywords
	}
	
	def findNonTerminalKeywords(Iterable<? extends AbstractRule> rules){
		rules
		.reject(TerminalRule)
		.flatMap[eAllContents.filter(Keyword).toIterable]
		.map[value]
		.filter[ID_PATTERN.matcher(it).matches]
		.toSet;
	}
	
	def showKeywords(Set<String> keywords){
		keywords.sort.map["\t| '" + it + "'\n"].join
	}
}
