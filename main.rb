require "erb"
require "date"

$tickets_list = []

email = {
  title: "Talent Acquisition Sprint Update",
  sprint_end_date: "#{(Time.now).strftime("%B")} #{Time.now.day}, #{Time.now.year}",
  edito: "Kudos to Oksana, Marina, Fabien, Lancelot and Sophie for the great work this week!",
  first_section: {
    title: "Jobs & Credits",
    statuses: ['DONE', 'CLOSED'],
    file: 'jobs_credits.txt',
    new_features: {
      type: "New Feature",
      nb_tickets: 0,
      tickets: []
    },
    improvements: {
      type: "Improvement",
      nb_tickets: 0,
      tickets: []
    },
    tasks: {
      type: "Task",
      nb_tickets: 0,
      tickets: []
    },
    bugs: {
      type: "Bug",
      nb_tickets: 0,
      tickets: []
    },
  },
  second_section: {
    title: "Company Pages",
    statuses: ['DONE', 'CLOSED'],
    file: 'company_pages.txt',
    new_features: {
      type: "New Feature",
      nb_tickets: 0,
      tickets: []
      },
    improvements: {
      type: "Improvement",
      nb_tickets: 0,
      tickets: []
    },
    tasks: {
      type: "Task",
      nb_tickets: 0,
      tickets: []
    },
    bugs: {
      type: "Bug",
      nb_tickets: 0,
      tickets: []
    },
  },
  third_section: {
    title: "Crawlers",
    statuses: ['DONE', 'CLOSED'],
    file: 'crawlers.txt',
    new_features: {
      type: "New Feature",
      nb_tickets: 0,
      tickets: []
    },
    improvements: {
      type: "Improvement",
      nb_tickets: 0,
      tickets: []
    },
    tasks: {
      type: "Task",
      nb_tickets: 0,
      tickets: []
    },
    bugs: {
      type: "Bug",
      nb_tickets: 0,
      tickets: []
    }
  },
  fourth_section: {
    title: "Technical",
    statuses: ['DONE', 'CLOSED'],
    file: 'technical.txt',
    new_features: {
      type: "New Feature",
      nb_tickets: 0,
      tickets: []
    },
    improvements: {
      type: "Improvement",
      nb_tickets: 0,
      tickets: []
    },
    tasks: {
      type: "Task",
      nb_tickets: 0,
      tickets: []
    },
    bugs: {
      type: "Bug",
      nb_tickets: 0,
      tickets: []
    }
  }
}

def section_looper(email)
  section = [:first_section, :second_section, :third_section, :fourth_section]
  section.each do |section|
    type_looper(email, section)
  end
end

def type_looper(email, section)
  type = [:new_features, :improvements, :tasks, :bugs]
  type.each do |type|
    tickets_looper(email, section, email[section][type][:type], email[section][:file], email[section][:statuses], email[section][type][:tickets], email[section][type])
  end
end

def tickets_looper(email, section, type, file, statuses, tickets, lol)
  i = 0
  File.open(file).readlines.each do |line|
    if line.include?(type) && statuses.inject(false) { |memo, status| line.include?(status) || memo }
      unless $tickets_list.include?(line.split("\t")[1])
      tickets << line.split("\t")[1]
      i = i + 1
      end
    end
  end

  if i>0
    $tickets_list = tickets + ($tickets_list - tickets)
    lol[:nb_tickets] = i
  end
end

def pluralize(string, n)
  if n > 1
    return "#{string}s"
  else
    return "#{string}"
  end
end

section_looper(email)
puts email

@email = email
#puts mail_builder()

@nb_new_features = @email[:first_section][:new_features][:nb_tickets] + @email[:second_section][:new_features][:nb_tickets] + @email[:third_section][:new_features][:nb_tickets] + @email[:fourth_section][:new_features][:nb_tickets]
@nb_bugs = @email[:first_section][:bugs][:nb_tickets] + @email[:second_section][:bugs][:nb_tickets] + @email[:third_section][:bugs][:nb_tickets] + @email[:fourth_section][:bugs][:nb_tickets]
@nb_improvements = @email[:first_section][:improvements][:nb_tickets] + @email[:second_section][:improvements][:nb_tickets] + @email[:third_section][:improvements][:nb_tickets] + @email[:fourth_section][:improvements][:nb_tickets]
@nb_tasks = @email[:first_section][:tasks][:nb_tickets] + @email[:second_section][:tasks][:nb_tickets] + @email[:third_section][:tasks][:nb_tickets] + @email[:fourth_section][:tasks][:nb_tickets]

# render template
template = File.read('./template.html.erb')
result = ERB.new(template).result(binding)

# write result to file
# File.open('filename.html', 'w+') do |f|
File.open('sprint_update.html', 'w+') do |f|
  f.write result
end
